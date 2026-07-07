import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';

class ProjectFunctionalController extends GetxController with PopupMixin {
  ProjectFunctionalController(this.captureProjectVideo);

  final CaptureProjectVideo captureProjectVideo;

  final RxnBool isFunctionalProject = RxnBool();
  final timelineController = TextEditingController();
  final RxInt finishedPercentage = 0.obs;
  final RxBool isFinishedPercentageAnswered = false.obs;
  final RxnBool stillWorkingOnProject = RxnBool();
  final RxString videoPath = ''.obs;
  final RxBool isSubmitting = false.obs;

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

    if (isFunctionalProject.value == true) {
      if (timelineController.text.trim().isEmpty ||
          !isFinishedPercentageAnswered.value ||
          stillWorkingOnProject.value == null) {
        showErrorDialog(
          Get.context!,
          message: 'Please answer all questionnaire details.',
        );
        return;
      }

      if (videoPath.value.isEmpty) {
        showErrorDialog(Get.context!, message: 'Please upload video.');
        return;
      }
    }

    isSubmitting.value = true;
    try {
      Get.snackbar(
        'Submitted',
        'Project functional details submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    timelineController.dispose();
    super.onClose();
  }
}
