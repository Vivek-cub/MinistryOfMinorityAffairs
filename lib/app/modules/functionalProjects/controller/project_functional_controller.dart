import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/community_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/dwf_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/educational_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/girls_hostel_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/health_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/indoor_sports_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/laboratory_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/market_shed_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/operation_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/skill_development_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/playground_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/toilet_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/women_centric_infrastructure_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/json/women_community_json.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/model/dynamic_form_config_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/entity/dynamic_form_config.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/repo/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/capture_image_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/geofence_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class ProjectFunctionalController extends GetxController
    with
        SnackBarMixin,
        PopupMixin,
        CompressMixin,
        CaptureImageMixin,
        GeofenceMixin {
  ProjectFunctionalController(
    this.captureProjectVideo,
    this.repo,
    this.repository,
    this.authService,
  );

  final CaptureProjectVideo captureProjectVideo;
  final ProjectFunctionalRepo repo;
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

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  RxMap<String, dynamic> initialValue = RxMap();
  final Rxn<DynamicFormConfig> dynamicFormConfig = Rxn<DynamicFormConfig>();
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

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? UnitDetails();
      projectId.value = data.value.id ?? '';
      isFunctional.value = args['isFunctional'] ?? false;
      if (isFunctional.value == true) {
        selectFunctionalProject(isFunctional.value);
      }
      debugPrint("project Id: ${projectId.value}");
    }
    _loadCurrentForm();
  }

  void _loadDynamicForm({
    required Map<String, dynamic> formConfig,
    required Map<String, dynamic> initialValues,
  }) {
    final config = Map<String, dynamic>.from(formConfig);

    final fields = List<Map<String, dynamic>>.from(config['fields'] ?? []);

    for (final field in fields) {
      final fieldName = field['name']?.toString();

      if (fieldName != null && initialValues.containsKey(fieldName)) {
        field['value'] = initialValues[fieldName];
      }
    }

    config['fields'] = fields;

    dynamicFormHeading.value = config['pageHeading']?.toString() ?? '';

    dynamicFormConfig.value = DynamicFormConfigModel.fromJson(config);

    initialValue.value = Map<String, dynamic>.from(initialValues);

    dynamicFormValue.value = Map<String, dynamic>.from(initialValues);

    debugPrint('Dynamic form config loaded');

    debugPrint('Initial values: ${initialValue.value}');

    _patchInitialValuesAfterBuild();
  }

  void _patchInitialValuesAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      patchInitialValuesToForm();
    });
  }

  void patchInitialValuesToForm() {
    final fields = formKey.currentState?.fields;
    if (fields == null || fields.isEmpty) return;

    for (final entry in initialValue.entries) {
      final field = fields[entry.key];
      if (field == null) continue;

      final value = _valueForFormField(entry.key, entry.value);
      field.didChange(value);
    }

    dynamicFormValue.value = Map<String, dynamic>.from(
      formKey.currentState?.instantValue ?? initialValue,
    );
  }

  dynamic _valueForFormField(String fieldName, dynamic value) {
    if (_fieldType(fieldName) == 'date') {
      if (value is DateTime) {
        debugPrint('$fieldName → DateTime: $value');
        return value;
      }

      if (value == null || value.toString().trim().isEmpty) {
        debugPrint('$fieldName → NULL');
        return null;
      }

      final parsed =
          _parseDisplayDate(value.toString()) ??
          DateTime.tryParse(value.toString());

      debugPrint(
        '$fieldName → original: $value '
        '(${value.runtimeType}) → parsed: $parsed '
        '(${parsed.runtimeType})',
      );

      return parsed;
    }

    return value;
  }

  DateTime? _parseDisplayDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return null;

    return DateTime(year, month, day);
  }

  String? _fieldType(String fieldName) {
    for (final field in dynamicFormConfig.value?.fields ?? []) {
      if (field.name == fieldName) return field.type;
    }
    return null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatGeoCoordinates(double? lat, double? lng) {
    if (lat == null || lng == null) return '';
    return '$lat, $lng';
  }

  String? get displayedVideoPath {
    if (videoPath.value.isEmpty) return null;
    return videoPath.value;
  }

  void selectFunctionalProject(bool value) {
    isFunctionalProject.value = value;

    if (!value) {
      clearQuestionnaire();
      clearVideoSelection();
    }
  }

  void updateFinishedPercentage(int value) {
    finishedPercentage.value = value;
    isFinishedPercentageAnswered.value = true;
  }

  void clearQuestionnaire() {
    timelineController.clear();
    finishedPercentage.value = 0;
    isFinishedPercentageAnswered.value = false;
    stillWorkingOnProject.value = null;
    formKey.currentState?.reset();
    dynamicFormValue.value = Map<String, dynamic>.from(initialValue);
  }

  void onDynamicFormChanged() {
    final formValue = formKey.currentState?.instantValue ?? {};
    dynamicFormValue.value = Map<String, dynamic>.from(formValue);
    _patchEnrollmentIncrease(formValue);
  }

  void _patchEnrollmentIncrease(Map<String, dynamic> formValue) {
    final current = _parseNumber(formValue['currentStudentEnrolment']);
    final before = _parseNumber(formValue['studentEnrolmentBeforeProject']);
    if (current == null || before == null) return;

    final value = current - before;
    final displayValue =
        value % 1 == 0 ? value.toInt().toString() : value.toString();
    final field = formKey.currentState?.fields['increaseInEnrolment'];
    if (field?.value?.toString() == displayValue) return;
    field?.didChange(displayValue);
    dynamicFormValue['increaseInEnrolment'] = displayValue;
  }

  num? _parseNumber(dynamic value) {
    if (value == null) return null;
    return num.tryParse(value.toString().trim());
  }

  Future<void> onCaptureVideo() async {
    SnackBarMixin().showAlertCustom(
      backBtnDisable: true,
      title: "Fetching Location...",
    );
    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
      data.value.unitProject?.stateName ?? "",
    );
    Get.back();

    if (insideGeofence == false) {
      //controller.showPhotoSourceDialog(index);
      PopupMixin().showErrorDialog(
        Get.context!,
        message: "You are outside the location",
      );
      return;
    }

    try {
      final compressedFile = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),
      );

      if (compressedFile == null) return;
      videoPath.value = compressedFile.path;
    } catch (e) {
      showErrorDialog(
        Get.context!,
        message: 'Unable to capture video. Please try again.',
      );
    }
  }

  void clearVideoSelection() {
    videoPath.value = '';
  }

  Future<void> submitData() async {
    if (isFunctionalProject.value == null) {
      showErrorDialog(
        Get.context!,
        message: 'Please select if the project is functional.',
      );
      return;
    }

    if (projectId.value.isEmpty) {
      showErrorDialog(Get.context!, message: 'Project id is missing.');
      return;
    }

    if (isFunctionalProject.value == true && videoPath.value.isEmpty) {
      showErrorDialog(Get.context!, message: 'Please upload video.');
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final hasInternet = await NetworkService.hasInternet();
    if (hasInternet) {
      await submitOnline();
    } else {
      showMessageDialog(
        Get.context!,
        title: "NO Internet!",
        message: "Want to save this in Local Database?",
        onPressed: () async {
          await saveOffline();
        },
      );
      isSubmitting.value = false;
    }
  }

  Future<void> submitOnline() async {
    try {
      // API 1: Submit questionnaire
      if (isFunctionalProject.value == true) {
        final questionnaireSuccess = await submitQuestionnaireOnline();

        if (!questionnaireSuccess) {
          return;
        }
      }

      // API 2: Upload functionality + video
      final uploadSuccess = await uploadFunctionalityOnline();

      if (!uploadSuccess) {
        await closeLoadingDialog();
        return;
      }

      // Both APIs succeeded
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      showSuccessDialog(
        Get.context!,
        message: "Your data is submitted successfully",
        onPressed: () async {
          Helpers().refreshHomeIfAvailable();
          await _navigateToDashboard();
        },
      );
    } catch (e) {
      debugPrint("submitOnline error: $e");

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      showErrorDialog(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> submitQuestionnaireOnline() async {
    try {
      final unitId = data.value.id ?? '';

      if (unitId.isEmpty) {
        throw Exception("Unit code is missing.");
      }

      showAlertCustom(backBtnDisable: true, title: "Submitting...");

      final formValues = _buildSectionPostData();

      debugPrint("========== QUESTIONNAIRE SUBMIT ==========");
      debugPrint("Unit ID: $unitId");
      debugPrint("Form Values: $formValues");

      final response = await repo.submitQuestionnaire(
        unitId: unitId,
        formValues: formValues,
      );

      debugPrint("Questionnaire response: ${response.statusCode}");

      if (response.statusCode == '200') {
        return true;
      }

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      showErrorDialog(
        Get.context!,
        title: "Error",
        message: response.error ?? "Failed to submit questionnaire.",
      );

      return false;
    } catch (e) {
      debugPrint("submitQuestionnaireOnline error: $e");

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      showErrorDialog(
        Get.context!,
        title: "Error",
        message: "Failed to submit questionnaire.",
      );

      return false;
    }
  }

  Future<bool> uploadFunctionalityOnline() async {
    try {
      // Close "Submitting..." dialog
      await closeLoadingDialog();

      // Show "Uploading..." dialog
      showAlertCustom(backBtnDisable: true, title: "Uploading...");

      final response = await repo.updateFunctionality(
        projectId: projectId.value,
        isFunctional: isFunctionalProject.value ?? false,
        videoPath:
            isFunctionalProject.value == true && videoPath.value.isNotEmpty
                ? videoPath.value
                : null,
      );

      // API success
      if (response.statusCode == '200') {
        await closeLoadingDialog();

        return true;
      }

      // API returned failure without throwing
      await closeLoadingDialog();

      showErrorDialog(
        Get.context!,
        title: "Upload Failed",
        message: response.error ?? "Something went wrong.",
      );

      return false;
    } on DioException catch (e) {
      debugPrint('========== FUNCTIONALITY API ERROR ==========');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('=============================================');

      // FIRST close "Uploading..." dialog
      await closeLoadingDialog();

      // THEN show error dialog
      showErrorDialog(
        Get.context!,
        title: "Upload Failed",
        message:
            e.response?.data?['statusMessage']?.toString() ??
            "Failed to upload functionality data.",
      );

      return false;
    } catch (e) {
      debugPrint("uploadFunctionalityOnline error: $e");

      // FIRST close "Uploading..." dialog
      await closeLoadingDialog();

      // THEN show error dialog
      showErrorDialog(
        Get.context!,
        title: "Upload Failed",
        message: "Something went wrong while uploading.",
      );

      return false;
    }
  }

  Map<String, dynamic> _jsonFormPayload() {
    final savedValues =
        formKey.currentState?.value ?? const <String, dynamic>{};
    final instantValues =
        formKey.currentState?.instantValue ?? const <String, dynamic>{};
    final payload = <String, dynamic>{};

    for (final field in dynamicFormConfig.value?.fields ?? []) {
      if (field.type == 'labelText') continue;

      final rawValue =
          savedValues[field.name] ??
          instantValues[field.name] ??
          dynamicFormValue[field.name] ??
          initialValue[field.name] ??
          field.value;

      payload[field.name] = _serializeFormValue(rawValue);
    }

    return payload;
  }

  dynamic _serializeFormValue(dynamic value) {
    if (value is DateTime) return _formatDate(value);
    return value ?? '';
  }

  Future<void> saveOffline() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: "Unable to identify current user");
      isSubmitting.value = false;
      return;
    }

    final questionnairePayload =
        isFunctionalProject.value == true ? jsonEncode(_jsonFormPayload()) : '';

    await repository.save(
      userId: userId,
      projectId: projectId.value,
      images: const [],
      videoPath:
          isFunctionalProject.value == true && videoPath.value.isNotEmpty
              ? videoPath.value
              : null,
      remarks: '',
      questionnairePayload: questionnairePayload,
      isSynced: false,
      userLat: userLat.value.toString(),
      userLng: userLng.value.toString(),
      progress: OfflineSubmissionType.functionalProject,
      projectStatus: (isFunctionalProject.value ?? false).toString(),
    );

    Helpers().refreshHomeIfAvailable();
    Get.back();
    Get.snackbar(
      'Saved Offline',
      'No internet. Data will sync automatically',
      snackPosition: SnackPosition.BOTTOM,
    );
    isSubmitting.value = false;
  }

  Future<void> _navigateToDashboard() async {
    Get.offAllNamed(await authService.dashboardRoute());
  }

  @override
  void onClose() {
    timelineController.dispose();
    super.onClose();
  }

  Future<void> _loadCurrentForm() async {
    final config = _getFormConfig();
    final unitId = data.value.id ?? '';

    if (unitId.isEmpty) {
      debugPrint('Unit ID is empty');
      isFormLoading(false);
      return;
    }

    try {
      isFormLoading(true);

      final response = await repo.getQuestionaire(unitId: unitId);

      if (response == null) {
        debugPrint('Questionnaire response is null');
        return;
      }

      debugPrint('========== QUESTIONNAIRE RESPONSE ==========');
      debugPrint(response.toString());
      debugPrint('============================================');

      // IMPORTANT:
      // API fields are inside response['data']
      final apiData = Map<String, dynamic>.from(response['data'] ?? {});

      debugPrint('========== API DATA ==========');
      debugPrint(apiData.toString());
      debugPrint('==============================');

      final initialValues = _getInitialValues(apiValues: apiData);

      debugPrint('========== INITIAL FORM VALUES ==========');
      debugPrint(initialValues.toString());
      debugPrint('=========================================');

      _loadDynamicForm(formConfig: config, initialValues: initialValues);

      // Make sure FormBuilder receives the values
      // _patchInitialValuesAfterBuild();
    } catch (e, stackTrace) {
      debugPrint('Questionnaire API error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isFormLoading(false);
    }
  }

  Map<String, dynamic> _getInitialValues({
    required Map<String, dynamic> apiValues,
  }) {
    final config = _getFormConfig();

    final initialValues = <String, dynamic>{};

    for (final field in config['fields'] ?? []) {
      final fieldName = field['name']?.toString();

      if (fieldName == null) {
        continue;
      }

      dynamic value;

      if (fieldName == 'geoCoordinates') {
        final lat = apiValues['latitude'];
        final lng = apiValues['longitude'];

        if (lat != null && lng != null) {
          value = '$lat, $lng';
        }
      } else {
        final apiKey = _fieldApiKeyMap[fieldName] ?? fieldName;

        value = apiValues[apiKey];
      }

      if (value != null) {
        initialValues[fieldName] = value;
      }
    }

    debugPrint('DYNAMIC INITIAL VALUES: $initialValues');

    return initialValues;
  }

  String _formatGeoCoordinatesFromString(String? latitude, String? longitude) {
    if (latitude == null ||
        longitude == null ||
        latitude.isEmpty ||
        longitude.isEmpty) {
      return '';
    }

    return '$latitude, $longitude';
  }

  Future<void> submitQuestionnaire() async {
    try {
      // Get latest values directly from FormBuilder
      final formValues =
          formKey.currentState?.instantValue ?? <String, dynamic>{};

      if (formValues.isEmpty) {
        debugPrint('Questionnaire form values are empty');
        return;
      }

      final unitId = data.value.unitCode ?? '';

      if (unitId.isEmpty) {
        debugPrint('Unit id is empty');
        return;
      }

      debugPrint('========== QUESTIONNAIRE DATA ==========');
      debugPrint('Unit ID: $unitId');
      debugPrint('Form Values: $formValues');
      debugPrint('========================================');

      final response = await repo.submitQuestionnaire(
        unitId: unitId,
        formValues: Map<String, dynamic>.from(formValues),
      );

      debugPrint(
        'Questionnaire submit response: '
        '${response.statusCode}',
      );

      if (response.statusCode == "200") {
        Get.snackbar(
          'Success',
          response.statusMessage ?? 'Questionnaire submitted successfully',
        );
      } else {
        Get.snackbar(
          'Error',
          response.statusMessage ?? 'Failed to submit questionnaire',
        );
      }
    } catch (e) {
      debugPrint('submitQuestionnaire controller error: $e');

      Get.snackbar(
        'Error',
        'Something went wrong while submitting questionnaire',
      );
    }
  }

  static const Map<String, String> _fieldApiKeyMap = {
    'blockTown': 'block/town',
    'pmjvkProjectId': 'projectUniqueId',
    'subSectorProjectType': 'projectType',
  };

  Map<String, dynamic> _buildSectionPostData() {
    final data = <String, dynamic>{};
    final fields = dynamicFormConfig.value?.fields ?? [];

    for (final field in fields) {
      if (field.type == 'labelText') continue;

      final rawValue = formKey.currentState?.fields[field.name]?.value;

      data[field.name] =
          rawValue is DateTime ? _formatDate(rawValue) : rawValue;
    }

    return data;
  }

  Map<String, dynamic> _getFormConfig() {
    final subtype = data.value.unitProject?.msdpItemsName
        ?.trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s*\[type\s*\d+\]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');

    switch (subtype) {
      // =========================================================
      // EDUCATION
      // Education - School Building / Additional Classroom
      // =========================================================
      case 'acr blocks':
      case 'computers':
      case 'drinking water facilities':
      case 'library':
      case 'smart classrooms/equipment':
      case 'agriculture college':
      case 'degree college':
      case 'medical college':
      case 'nursing college':
      case 'new school buidling':
      case 'smart classroom/teaching aids':
      case 'staff quarters':
      case 'toilet':
      case 'hostel for school':
      case 'iay':
      case 'classroom/ lecture hall':
      case 'other infrastructure in existing school':
      case 'addtional infrastructure':
      case 'furniture':
      case 'bicycle':
      case 'room':
        return EducationalJson.educationalSection;

      // =========================================================
      // GIRLS HOSTEL
      // =========================================================
      case 'girls hostel for school':
      case 'girls hostel for college/ university':
      case 'girls hostel for iti’s':
      case "girls hostel for iti's":
      case 'girls hostel for polytechnic':
      case 'girls hostel standalone':
      case 'boundary walls for girls hostel':
      case 'hostel facility':
        return GirlsHostelJson.girlsHostelSection;

      // =========================================================
      // LABORATORY
      // Laboratory at School
      // =========================================================
      case 'laboratory':
        return LaboratoryJson.laboratorySection;

      // =========================================================
      // HEALTH
      // Health Sector - PHC / CHC / Hospital
      // =========================================================
      case 'general hospital':
      case 'super speciality hospital':
      case 'ayurvedic hospital':
      case 'yoga & naturopathy hospital':
      case 'unani hospital':
      case 'siddha hospital':
      case 'homeopathy hospital':
      case 'ot (operation theatre)':
      case 'nicu (neonatal intensive care unit)':
      case 'opd (outpatient department)':
      case 'ipd (in patient department)':
      case 'machinery':
      case 'chc (common service center)':
      case 'phc (primary health center)':
      case 'hsc (health sub center)':
      case 'phsc (primary health sub center)':
      case 'district hospital':
      case 'sub-district hospital':
      case 'chw (centre for health and wellness)':
      case 'nursing hospital':
      case 'dispensary':
      case 'ayush':
      case 'chc':
      case 'hsc':
      case 'phc':
      case 'phsc':
        return HealthJson.healthSection;

      // =========================================================
      // SKILL DEVELOPMENT
      // Skill Development Centre / ITI / Polytechnic
      // =========================================================
      case 'new iti':
      case 'new polytechnic':
      case 'training':
      case 'skill centres':
      case 'additional building':
      case 'workshop':
      case 'equipment':
      case 'boys hostel for iti’s':
      case "boys hostel for iti's":
      case 'boys hostel for polytechnic':
      case 'hostel for iti':
        return SkillDevelopmentJson.skillDevelopmentSection;

      // =========================================================
      // WOMEN-CENTRIC INFRASTRUCTURE
      // Working Women Hostel
      // =========================================================
      case 'working women hostel':
        return WomenCentricInfrastructureJson.womenCentricInfrastructureSection;

      // =========================================================
      // WOMEN COMMUNITY CENTRE
      // =========================================================
      case 'women community centre':
      case 'wcc':
        return WomenCommunityJson.womencommunitySection;

      // =========================================================
      // SPORTS - PLAYGROUND
      // =========================================================
      case 'playground':
      case 'sports-stadium':
      case 'sports complex':
      case 'football turf':
      case 'swimming pool':
      case 'hockey turf':
      case 'stadium':
      case 'volleyball court':
      case 'basketball court':
        return PlaygroundJson.playgroundSection;

      // =========================================================
      // SPORTS - INDOOR STADIUM / SPORTS COMPLEX
      // =========================================================
      case 'indoor hall':
      case 'multipurpose hall':
        return IndoorSportsJson.indoorSportsection;

      // =========================================================
      // COMMUNITY INFRASTRUCTURE
      // Community Hall / Sadbhav Mandap
      // =========================================================
      case 'community service centre/ sadbhav mandap/ community hall':
      case 'hunar hub':
      case 'cybergram':
        return CommunityJson.communitySection;

      // =========================================================
      // DRINKING WATER FACILITY
      // =========================================================
      case 'drinking water infrastructure':
      case 'dws':
      case 'hand pump':
        return DwfJson.dwfSection;

      // =========================================================
      // TOILET COMPLEX
      // =========================================================
      case 'toilets':
        return ToiletJson.toiletSection;

      // =========================================================
      // MARKET SHED
      // =========================================================
      case 'market shed':
        return MarketShedJson.marketShedSection;

      // =========================================================
      // DEFAULT
      // =========================================================
      default:
        debugPrint(
          'No form config found for MSDP subtype: '
          '${data.value.unitProject?.msdpItemsName}',
        );

        return <String, dynamic>{
          'pageHeading': '',
          'fields': <Map<String, dynamic>>[],
        };
    }
  }
}
