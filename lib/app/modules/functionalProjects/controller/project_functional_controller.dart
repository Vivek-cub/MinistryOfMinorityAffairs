import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/project_functional_repo.dart';
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

  @override
  RxDouble userLat = 0.0.obs;

  @override
  RxDouble userLng = 0.0.obs;

  @override
  RxBool isInsideFence = false.obs;

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
      debugPrint("project Id: ${projectId.value}");
    }
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
  }

  Future<void> onCaptureVideo() async {
    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
    );

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

    if (isFunctionalProject.value == true) {
      if (videoPath.value.isEmpty) {
        showErrorDialog(Get.context!, message: 'Please upload video.');
        return;
      }
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
      showAlertCustom(backBtnDisable: true, title: "Uploading...");
      final modelData = await repo.updateFunctionality(
        projectId: projectId.value,
        isFunctional: isFunctionalProject.value ?? false,
        videoPath:
            isFunctionalProject.value == true && videoPath.value.isNotEmpty
                ? videoPath.value
                : null,
      );

      if (modelData.statusCode == '200') {
        Get.back();
        showSuccessDialog(
          Get.context!,
          message: "Your data is submitted successfully",
          onPressed: () async {
            Helpers().refreshHomeIfAvailable();
            await _navigateToDashboard();
          },
        );
      } else {
        Get.back();
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.error ?? "Something went wrong.",
        );
      }
    } catch (e) {
      Get.back();
      showErrorDialog(
        Get.context!,
        title: "Error",
        message: "Something went wrong.",
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> saveOffline() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: "Unable to identify current user");
      isSubmitting.value = false;
      return;
    }

    await repository.save(
      userId: userId,
      projectId: projectId.value,
      images: const [],
      videoPath:
          isFunctionalProject.value == true && videoPath.value.isNotEmpty
              ? videoPath.value
              : null,
      remarks: '',
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
}
