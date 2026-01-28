import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:image_picker/image_picker.dart';

/// Work Detail controller
/// Manages state and business logic for Work Detail screen
class WorkDetailController extends GetxController {
  final ProjectModel project;

  // Photo paths
  final photos = <String?>[null, null, null].obs;

  // Remarks controller
  final remarksController = TextEditingController();

  // Loading state
  final isSubmitting = false.obs;

  WorkDetailController({required this.project});

  @override
  void onInit() {
    super.onInit();
    // Initialize project with default values if missing
    _initializeProjectData();
  }

  void _initializeProjectData() {
    // If project doesn't have extended fields, set defaults based on location
    // This is a fallback - in real app, these would come from API
    if (project.state == null || project.district == null) {
      final locationParts = project.location.split(',');
      if (locationParts.length >= 2) {
        // Parse location string to extract district/state info
        // This is a simple example - adjust based on your data format
      }
    }
  }

  /// Take photo using camera
  Future<void> takePhoto(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        photos[index] = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Pick photo from gallery
  Future<void> pickPhotoFromGallery(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        photos[index] = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick photo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Show photo source selection dialog
  void showPhotoSourceDialog(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Photo Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                takePhoto(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Get.back();
                pickPhotoFromGallery(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Handle microphone tap for voice input
  void onMicrophoneTap() {
    // TODO: Implement voice input functionality
    Get.snackbar(
      'Voice Input',
      'Voice input feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Submit work detail update
  Future<void> submitUpdate() async {
    if (isSubmitting.value) return;

    isSubmitting.value = true;

    try {
      // TODO: Implement API call to submit work detail update
      // Example:
      // final apiService = Get.find<ApiService>();
      // await apiService.post('/work-details/${project.id}', {
      //   'photos': photos.where((p) => p != null).toList(),
      //   'remarks': remarksController.text,
      // });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Work detail updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      // Navigate back
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update work detail: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }
}
