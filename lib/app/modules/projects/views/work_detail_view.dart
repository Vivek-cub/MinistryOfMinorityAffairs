import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/photo_upload_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/remarks_input_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_detail_info_widget.dart';
import '../controllers/work_detail_controller.dart';

/// Work Detail view
/// Displays work details and allows updating progress with photos and remarks
class WorkDetailView extends GetView<WorkDetailController> {
  const WorkDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primary,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              Column(
                children: [
                  // Header with search icon
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      WorkProgressHeader(
                        userName: 'User Name',
                        title: 'Work Detail',
                        subtitle: 'Track Progress of works in real-time',
                        avatarAssetPath: 'assets/images/emblem.png',
                      ),
                      // Search icon in header
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 20,
                        right: 20,
                        child: IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // TODO: Implement search functionality
                          },
                        ),
                      ),
                    ],
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Work Detail Info
                          WorkDetailInfoWidget(project: controller.project),
                          const SizedBox(height: 24),
                          // Photo Upload Section
                          const Text(
                            'Photos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Obx(
                            () => Row(
                              children: List.generate(3, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: index < 2 ? 12 : 0,
                                    ),
                                    child: PhotoUploadWidget(
                                      imagePath: controller.photos[index],
                                      onTap:
                                          () => controller
                                              .showPhotoSourceDialog(index),
                                      label: 'Tap to take a photo',
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Remarks Section
                          const Text(
                            'Remarks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RemarksInputWidget(
                            controller: controller.remarksController,
                            hintText: 'Add context or observations (optional)',
                            onMicrophoneTap: controller.onMicrophoneTap,
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 100,
                          ), // Space for submit button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Footer with Submit Button
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513), // Brown color from screenshot
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: Obx(
              () => GradientButton(
                text: 'Submit',
                onPressed:
                    controller.isSubmitting.value
                        ? null
                        : controller.submitUpdate,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
