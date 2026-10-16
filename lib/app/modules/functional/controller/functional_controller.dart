import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/domain/functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/mixin/condition_evaluator.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/mixin/condition_validators.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/capture_image_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/geofence_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class FunctionalController extends GetxController
    with
        SnackBarMixin,
        PopupMixin,
        CompressMixin,
        CaptureImageMixin,
        GeofenceMixin,
        ConditionValidators {
  FunctionalController(
    this.captureProjectVideo,
    this.repo,
    this.repository,
    this.authService,
  );
  final CaptureProjectVideo captureProjectVideo;
  final FunctionalRepo repo;
  final SubmissionRepository repository;
  final AuthService authService;

  final RxnBool isFunctionalProject = RxnBool();
  final timelineController = TextEditingController();
  final RxInt finishedPercentage = 0.obs;
  final RxBool isFinishedPercentageAnswered = false.obs;
  final RxnBool stillWorkingOnProject = RxnBool();
  final RxString videoPath = ''.obs;
  final RxBool isSubmitting = false.obs;
  final Rx<UnitDetails> data = UnitDetails().obs;
  final RxString projectId = ''.obs;
  final RxString videoProjectId = ''.obs;

  RxMap<String, dynamic> initialValue = RxMap();
  final RxString dynamicFormHeading = ''.obs;
  final RxMap<String, dynamic> dynamicFormValue = RxMap<String, dynamic>();

  @override
  RxDouble userLat = 0.0.obs;

  @override
  RxDouble userLng = 0.0.obs;

  @override
  RxBool isInsideFence = false.obs;
  RxBool isFunctional = false.obs;
  final RxBool isFormLoading = true.obs;
  final Rxn<FunctionalResponseModel> questionnaire =
      Rxn<FunctionalResponseModel>();

  final RxList<FunctionalQuestion> dynamicFormConfig =
      <FunctionalQuestion>[].obs;

  /// Initial values from API.

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final RxMap<String, dynamic> questionAnswers = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? UnitDetails();
      projectId.value = data.value.projectId ?? '';
      videoProjectId.value = data.value.id ?? '';
      isFunctional.value = args['isFunctional'] ?? false;
      if (isFunctional.value == true) {
        selectFunctionalProject(isFunctional.value);
      }
      debugPrint("project Id: ${projectId.value}");
    }
    _loadQuestionnaire();
  }

  String? get displayedVideoPath {
    if (videoPath.value.isEmpty) return null;
    return videoPath.value;
  }

  Future<void> onCaptureVideo() async {
    bool locationLoaderShown = false;
    bool compressionLoaderShown = false;

    try {
      // ============================================================
      // 1. GET ACCURATE LOCATION
      // ============================================================
      showAlertCustom(backBtnDisable: true, title: "Fetching Location...");

      locationLoaderShown = true;

      final position = await LocationService.getAccurateLocation();

      final accuracy = position.accuracy;

      debugPrint("==========================================");
      debugPrint("VIDEO LOCATION");
      debugPrint("Latitude  : ${position.latitude}");
      debugPrint("Longitude : ${position.longitude}");
      debugPrint("Longitude : ${position.longitude}");
      debugPrint("Accuracy  : $accuracy m");
      final geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      debugPrint("Accuracy  : ${placemarks.first.subAdministrativeArea} ");
      debugPrint("Accuracy  : ${placemarks.first.administrativeArea} ");
      debugPrint("==========================================");

      // ============================================================
      // 2. ACCURACY MUST BE <= 15 METERS
      // ============================================================
      if (accuracy > 15) {
        if (locationLoaderShown) {
          Get.back();
          locationLoaderShown = false;
        }

        showErrorDialog(
          Get.context!,
          message:
              "Location accuracy is ${accuracy.toStringAsFixed(1)} meters.\n"
              "Please try again in an open area.",
        );

        return;
      }

      // Save validated location
      userLat.value = position.latitude;
      userLng.value = position.longitude;

      // ============================================================
      // 3. PROJECT LOCATION / BLOCK
      // ============================================================
      final projectLat = data.value.lat;
      final projectLng = data.value.lng;

      final blockName = data.value.unitProject?.blockTownName?.trim();
      final stateName = data.value.unitProject?.stateName?.trim();

      final hasLatLng =
          projectLat != null &&
          projectLng != null &&
          projectLat != 0.0 &&
          projectLng != 0.0;

      final hasState = stateName != null && stateName.isNotEmpty;
      final hasBlock = blockName != null && blockName.isNotEmpty;

      debugPrint("Project Lat : $projectLat");
      debugPrint("Project Lng : $projectLng");
      debugPrint("Block       : $blockName");
      debugPrint("Has LatLng  : $hasLatLng");
      debugPrint("Has Block   : $hasBlock");

      // ============================================================
      // 4. NO LAT/LNG + NO BLOCK = ERROR
      // ============================================================
      if (!hasLatLng && !(hasState && hasBlock)) {
        if (locationLoaderShown) {
          Get.back();
          locationLoaderShown = false;
        }

        showErrorDialog(
          Get.context!,
          message:
              "Project location is not configured. "
              "Valid coordinates or both state and block are required.",
        );

        return;
      }

      // ============================================================
      // 5. CHECK GEO-FENCE
      //
      // Lat/Lng available:
      //     → 200 meter radius
      //
      // Lat/Lng unavailable:
      //     → Block validation
      // ============================================================
      debugPrint("Checking geofence...");

      final insideGeofence = await checkGeoFence(
        lat: hasLatLng ? projectLat : null,
        lng: hasLatLng ? projectLng : null,
        blockName: hasBlock ? blockName : null,
        stateName: hasState ? stateName : null,
        position: position,
      );

      // Close location loader
      if (locationLoaderShown) {
        Get.back();
        locationLoaderShown = false;
      }

      debugPrint("Inside Geofence/Block: $insideGeofence");

      // ============================================================
      // 6. GEO-FENCE FAILED
      // ============================================================
      if (!insideGeofence) {
        showErrorDialog(
          Get.context!,
          message:
              hasLatLng
                  ? "You are outside the location."
                  : "You are outside the assigned block.",
        );

        return;
      }

      // ============================================================
      // 7. GEO-FENCE PASSED → CAPTURE VIDEO
      // ============================================================
      debugPrint("Geofence passed.");
      debugPrint("Starting video capture...");

      final compressedFile = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),

        // ==========================================================
        // 8. COMPRESSION STARTED
        // ==========================================================
        onCompressionStarted: () {
          debugPrint("Video compression started");

          if (!compressionLoaderShown) {
            showAlertCustom(
              backBtnDisable: true,
              title: "Compressing Video...",
            );

            compressionLoaderShown = true;
          }
        },
      );

      debugPrint("Video capture/compression completed.");

      // ============================================================
      // 9. VIDEO CANCELLED
      // ============================================================
      if (compressedFile == null) {
        debugPrint("Video capture cancelled.");

        if (compressionLoaderShown) {
          Get.back();
          compressionLoaderShown = false;
        }

        return;
      }

      // ============================================================
      // 10. SET VIDEO PATH
      // ============================================================
      videoPath.value = compressedFile.path;

      debugPrint("Video saved: ${compressedFile.path}");

      // ============================================================
      // 11. CHECK FINAL SIZE
      // ============================================================
      final finalSize = await compressedFile.length();

      debugPrint(
        "Final video size: "
        "${(finalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
      );

      // ============================================================
      // 12. CLOSE COMPRESSION LOADER
      // ============================================================
      if (compressionLoaderShown) {
        Get.back();
        compressionLoaderShown = false;
      }
    } catch (e, stackTrace) {
      debugPrint("Video capture error: $e");
      debugPrintStack(stackTrace: stackTrace);

      // Close location loader
      if (locationLoaderShown) {
        Get.back();
        locationLoaderShown = false;
      }

      // Close compression loader
      if (compressionLoaderShown) {
        Get.back();
        compressionLoaderShown = false;
      }

      showErrorDialog(Get.context!, message: e.toString());
    }
  }

  void clearVideoSelection() {
    videoPath.value = '';
  }

  Future<void> _loadQuestionnaire() async {
    try {
      isFormLoading.value = true;

      final unitId = projectId.value;

      /*
       * Change this only if your UnitDetails
       * has a different sectorId field.
       */
      final sectorId = data.value.sectorId?.toString() ?? '';

      if (unitId.isEmpty) {
        debugPrint('Unit ID is empty');
        return;
      }

      debugPrint('========== LOAD QUESTIONNAIRE ==========');
      debugPrint('unitId: $unitId');
      debugPrint('sectorId: $sectorId');

      final response = await repo.getQuestionaire(
        unitId: unitId,
        sectorId: sectorId,
      );

      questionnaire.value = response;

      dynamicFormConfig.assignAll(response.data ?? []);

      _setInitialValues();

      debugPrint(
        'Questionnaire count: '
        '${dynamicFormConfig.length}',
      );

      for (final question in dynamicFormConfig) {
        debugPrint(
          'IDs: ${question.questionId}, '
          'type: ${question.questionType}, '
          'answer: ${question.answer}',
        );
      }
    } catch (e) {
      debugPrint('Questionnaire error: $e');

      dynamicFormConfig.clear();

      showErrorDialog(
        Get.context!,
        title: 'Error',
        message: 'Unable to load questionnaire.',
      );
    } finally {
      isFormLoading.value = false;
    }
  }

  // ============================================================
  // INITIAL VALUES
  // ============================================================

  void _setInitialValues() {
    initialValue.clear();
    dynamicFormValue.clear();

    for (final question in dynamicFormConfig) {
      final questionId = question.questionId;

      if (questionId == null) {
        continue;
      }

      // HEADING does not have a form value.
      if (question.questionType == 'HEADING') {
        continue;
      }

      final fieldName = _fieldName(questionId);

      if (question.answer != null) {
        // FormBuilder value
        initialValue[fieldName] = question.answer;

        // Visibility value
        dynamicFormValue[questionId] = question.answer;
      }
    }

    debugPrint('Initial FormBuilder Values: $initialValue');

    debugPrint('Initial Dynamic Form Values: $dynamicFormValue');
  }

  // ============================================================
  // FIELD NAME
  // ============================================================

  String _fieldName(String questionId) {
    return 'question_$questionId';
  }

  // ============================================================
  // FORM CHANGED
  // ============================================================

  // void onDynamicFormChanged() {
  //   final values = formKey.currentState?.instantValue ?? <String, dynamic>{};

  //   dynamicFormValue
  //     ..clear()
  //     ..addAll(values);

  //   debugPrint('Form values: $dynamicFormValue');
  // }

  // ============================================================
  // PREPARE ASSESSMENT
  // ============================================================

  List<Map<String, dynamic>> prepareAssessment() {
    final values = formKey.currentState?.instantValue ?? <String, dynamic>{};
    final List<Map<String, dynamic>> assessment = [];

    for (final question in dynamicFormConfig) {
      final questionId = question.questionId;
      if (questionId == null) continue;
      if (question.questionType == 'HEADING') continue;

      // Don't submit answers for questions the user can't see.
      if (!visibility(question, this)) continue;

      dynamic answer = values[_fieldName(questionId)];

      // Untouched field -> fall back to the value from the API.
      if (answer == null && question.answer != null) {
        answer = question.answer;
      }
      if (answer == null) continue;
      if (answer is String && answer.trim().isEmpty) continue;

      // DATE
      if (answer is DateTime) {
        answer = _formatDate(answer, question.dateFormat);
      }

      // INTEGER -> int (sample: "answer": 10)
      if (question.questionType == 'INTEGER' && answer is String) {
        answer = int.tryParse(answer.trim());
        if (answer == null) continue;
      }

      // YES_NO -> "YES" / "NO" (sample: "answer": "NO")
      if (question.questionType == 'YES_NO') {
        final isYes =
            answer is bool
                ? answer
                : ConditionEvaluator.normalize(answer) == true;
        assessment.add({
          'questionId': questionId,
          'answer': isYes ? 'YES' : 'NO',
        });
        continue;
      }

      // IMAGE / VIDEO -> local path for now (see note about backend contract)
      // IMAGE / VIDEO
      if (question.questionType == 'IMAGE' ||
          question.questionType == 'IMAGES' ||
          question.questionType == 'VIDEO') {
        final value = answer.toString().trim();

        // Preserve existing remote media URLs.
        if (value.startsWith('http://') || value.startsWith('https://')) {
          assessment.add({'questionId': questionId, 'answer': value});
        } else {
          // New local media file.
          assessment.add({'questionId': questionId, 'answer': '__FILE__'});
        }

        continue;
      }

      assessment.add({'questionId': questionId, 'answer': answer});
    }

    return assessment;
  }

  // ---- media: skip hidden questions too --------------------------------------
  List<Map<String, dynamic>> getAssessmentMedia() {
    final values = formKey.currentState?.instantValue ?? <String, dynamic>{};
    final List<Map<String, dynamic>> media = [];

    for (final question in dynamicFormConfig) {
      final questionId = question.questionId;
      final type = question.questionType?.toUpperCase();

      if (questionId == null) continue;
      if (type != 'IMAGE' && type != 'IMAGES' && type != 'VIDEO') continue;
      if (!visibility(question, this)) continue;

      final path = values[_fieldName(questionId)]?.toString();
      if (path == null || path.trim().isEmpty) continue;

      media.add({'questionId': questionId, 'questionType': type, 'path': path});
    }

    return media;
  }

  String _formatDate(DateTime date, String? dateFormat) {
    /*
     * For your current API:
     * dd-MM-yyyy
     */
    if (dateFormat == 'dd-MM-yyyy') {
      return '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}';
    }

    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  Future<void> submitData() async {
    if (isSubmitting.value) {
      return;
    }

    try {
      isSubmitting.value = true;

      if (isFunctionalProject.value == true) {
        // debugPrint('==========================================');
        // debugPrint('PROJECT TYPE: FUNCTIONAL');
        // debugPrint('==========================================');

        final form = formKey.currentState;

        if (form == null) {
          debugPrint('Form is null.');

          showErrorDialog(
            Get.context!,
            title: 'Validation Error',
            message: 'Unable to validate questionnaire.',
          );

          return;
        }

        final isValid = form.saveAndValidate();

        if (!isValid) {
          debugPrint('Questionnaire validation failed.');

          showErrorDialog(
            Get.context!,
            title: 'Validation Error',
            message: 'Please complete all required fields.',
          );

          return;
        }

        debugPrint('Questionnaire validation successful.');

        // Update dynamic form values after validation.
        onDynamicFormChanged();

        if (videoPath.value.trim().isEmpty) {
          debugPrint('Video is required for functional project.');

          showErrorDialog(
            Get.context!,
            title: 'Video Required',
            message: 'Please upload a video before submitting.',
          );

          return;
        }

        debugPrint('Video validation successful.');
        debugPrint('Video path: ${videoPath.value}');

        final hasInternet = await NetworkService.hasInternet();
        if (!hasInternet) {
          showMessageDialog(
            Get.context!,
            title: 'NO Internet!',
            message: 'Want to save this in Local Database?',
            onPressed: () async {
              await saveOffline();
            },
          );
          return;
        }

        final questionnaireSuccess = await submitQuestionaire();

        if (!questionnaireSuccess) {
          debugPrint('Questionnaire submission failed.');
          return;
        }

        debugPrint('Questionnaire submission successful.');

        final functionalitySuccess = await updateFunctionality(
          uploadVideo: true,
        );

        if (!functionalitySuccess) {
          debugPrint('Functionality update failed.');
          return;
        }

        debugPrint('Functionality update successful.');

        showSuccessDialog(
          Get.context!,
          title: 'Success',
          message: 'Questionnaire and video submitted successfully.',
          onPressed: () async {
            Helpers().refreshHomeIfAvailable();
            await _navigateToDashboard();
          },
        );
      } else {
        debugPrint('==========================================');
        debugPrint('PROJECT TYPE: NON-FUNCTIONAL');
        debugPrint('==========================================');

        final hasInternet = await NetworkService.hasInternet();
        if (!hasInternet) {
          showMessageDialog(
            Get.context!,
            title: 'NO Internet!',
            message: 'Want to save this in Local Database?',
            onPressed: () async {
              await saveOffline();
            },
          );
          return;
        }

        final functionalitySuccess = await updateFunctionality(
          uploadVideo: false,
        );

        if (!functionalitySuccess) {
          debugPrint('Functionality update failed.');
          return;
        }

        debugPrint('Functionality update successful.');

        showSuccessDialog(
          Get.context!,
          title: 'Success',
          message: 'Project submitted successfully.',
          onPressed: () async {
            Helpers().refreshHomeIfAvailable();
            await _navigateToDashboard();
          },
        );
      }
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('SUBMIT DATA ERROR');
      debugPrint('$e');
      debugPrint('==========================================');

      await closeLoadingDialog();

      showErrorDialog(
        Get.context!,
        title: 'Error',
        message: 'Unable to submit data. Please try again.',
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  String _offlineQuestionnairePayload() {
    if (isFunctionalProject.value != true) return '';

    return jsonEncode({
      'formValues': {
        'assessmentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'answers': prepareAssessment(),
      },
      'media': getAssessmentMedia(),
    });
  }

  Future<void> saveOffline() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: 'Unable to identify current user');
      return;
    }

    final questionnaireMedia =
        isFunctionalProject.value == true ? getAssessmentMedia() : const [];

    await repository.save(
      userId: userId,
      projectId: projectId.value,
      images:
          questionnaireMedia
              .map((item) => item['path']?.toString() ?? '')
              .where((path) => path.isNotEmpty)
              .toList(),
      videoPath:
          isFunctionalProject.value == true && videoPath.value.isNotEmpty
              ? videoPath.value
              : null,
      remarks: '',
      questionnairePayload: _offlineQuestionnairePayload(),
      isSynced: false,
      userLat: userLat.value.toString(),
      userLng: userLng.value.toString(),
      progress: OfflineSubmissionType.functionalProject,
      projectStatus: (isFunctionalProject.value ?? false).toString(),
    );

    Helpers().refreshHomeIfAvailable();
    Get.snackbar(
      'Saved Offline',
      'No internet. Data will sync automatically',
      snackPosition: SnackPosition.BOTTOM,
    );
    await _navigateToDashboard();
  }

  Future<bool> submitQuestionaire() async {
    try {
      final payload = <String, dynamic>{
        'assessmentDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'answers': prepareAssessment(),
      };
      final media = getAssessmentMedia();

      debugPrint('QUESTIONNAIRE PAYLOAD: $payload');
      debugPrint('QUESTIONNAIRE MEDIA: $media');

      final response = await repo.submitQuestionnaire(
        unitId: projectId.value,
        formValues: payload,
        media: media,
      );

      debugPrint('Success: ${response.success}');
      debugPrint('Message: ${response.message}');
      debugPrint('Error  : ${response.error}');

      if (response.success == true) return true;

      showErrorDialog(
        Get.context!,
        title: 'Questionnaire Failed',
        message:
            response.error ??
            response.message ??
            'Unable to submit questionnaire.',
      );
      return false;
    } on DioException catch (e) {
      debugPrint('QUESTIONNAIRE API ERROR: ${e.response?.data}');
      showErrorDialog(
        Get.context!,
        title: 'Questionnaire Failed',
        message:
            e.response?.data?['statusMessage']?.toString() ??
            e.response?.data?['message']?.toString() ??
            'Unable to submit questionnaire.',
      );
      return false;
    } catch (e) {
      debugPrint('SUBMIT QUESTIONNAIRE ERROR: $e');
      showErrorDialog(
        Get.context!,
        title: 'Questionnaire Failed',
        message: 'Something went wrong while submitting questionnaire.',
      );
      return false;
    }
  }

  Future<bool> updateFunctionality({required bool uploadVideo}) async {
    try {
      showAlertCustom(
        backBtnDisable: true,
        title: uploadVideo ? 'Uploading...' : 'Submitting...',
      );

      debugPrint('==========================================');
      debugPrint('UPDATE FUNCTIONALITY');
      debugPrint('==========================================');
      debugPrint('Project ID      : ${videoProjectId.value}');
      debugPrint('Is Functional   : ${isFunctionalProject.value}');
      debugPrint('Upload Video    : $uploadVideo');
      debugPrint('Video Path      : ${videoPath.value}');
      debugPrint('==========================================');

      final String? video =
          uploadVideo && videoPath.value.trim().isNotEmpty
              ? videoPath.value
              : null;

      final response = await repo.updateFunctionality(
        projectId: videoProjectId.value,

        isFunctional: isFunctionalProject.value ?? false,

        videoPath: video,
      );

      debugPrint('==========================================');
      debugPrint('FUNCTIONALITY RESPONSE');
      debugPrint('==========================================');
      debugPrint('$response');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('==========================================');

      if (response.statusCode == '200') {
        await closeLoadingDialog();

        debugPrint('Functionality updated successfully.');

        return true;
      }

      await closeLoadingDialog();

      debugPrint('Functionality failed with status: ${response.statusCode}');

      showErrorDialog(
        Get.context!,
        title: 'Submission Failed',
        message: response.error ?? 'Something went wrong while submitting.',
      );

      return false;
    } on DioException catch (e) {
      debugPrint('==========================================');
      debugPrint('FUNCTIONALITY API ERROR');
      debugPrint('==========================================');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Error: $e');
      debugPrint('==========================================');

      await closeLoadingDialog();

      showErrorDialog(
        Get.context!,
        title: 'Submission Failed',
        message:
            e.response?.data?['statusMessage']?.toString() ??
            e.response?.data?['message']?.toString() ??
            'Failed to update functionality.',
      );

      return false;
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('UPDATE FUNCTIONALITY ERROR');
      debugPrint('==========================================');
      debugPrint('$e');
      debugPrint('==========================================');

      await closeLoadingDialog();

      showErrorDialog(
        Get.context!,
        title: 'Submission Failed',
        message: 'Something went wrong while updating functionality.',
      );

      return false;
    }
  }

  dynamic _projectIdAsInt() {
    return int.tryParse(projectId.value) ?? projectId.value;
  }

  void selectFunctionalProject(bool value) {
    isFunctionalProject.value = value;

    if (!value) {
      clearQuestionnaire();
      clearVideoSelection();
    }
  }

  void clearQuestionnaire() {
    dynamicFormValue.clear();
    initialValue.clear();

    formKey.currentState?.reset();
  }

  Future<void> _navigateToDashboard() async {
    Get.offAllNamed(await authService.dashboardRoute());
  }

  Future<String?> captureVideoForForm() async {
    try {
      final file = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),
      );

      if (file == null) {
        return null;
      }

      return file.path;
    } catch (e) {
      debugPrint('Capture video error: $e');
      return null;
    }
  }

  // List<Map<String, dynamic>> getAssessmentMedia() {
  //   final values = formKey.currentState?.instantValue ?? <String, dynamic>{};

  //   final List<Map<String, dynamic>> media = [];

  //   for (final question in dynamicFormConfig) {
  //     final questionId = question.questionId;
  //     final questionType = question.questionType?.toUpperCase();

  //     if (questionId == null) continue;

  //     if (questionType != 'IMAGE' && questionType != 'VIDEO') {
  //       continue;
  //     }

  //     final fieldName = _fieldName(questionId);
  //     final path = values[fieldName]?.toString();

  //     if (path == null || path.trim().isEmpty) {
  //       continue;
  //     }

  //     media.add({
  //       'questionId': questionId,
  //       'questionType': questionType, // internal only
  //       'path': path,
  //     });
  //   }

  //   return media;
  // }

  void onQuestionValueChanged(String questionId, dynamic value) {
    questionAnswers[questionId] = value;
    dynamicFormValue[questionId] = value;
  }

  // Only needed if you still call it; keeps keys as plain questionIds
  void onDynamicFormChanged() {
    final values = formKey.currentState?.instantValue ?? <String, dynamic>{};
    values.forEach((k, v) {
      dynamicFormValue[k.replaceFirst('question_', '')] = v;
    });
  }
}
