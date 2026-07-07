import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/photo_upload_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/remarks_input_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/urgent_work_details_info_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_detail_info_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/upload_project_details_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/audio_recorder_widget.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/capture_video_previews.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/function_toggle.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/project_selector.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/selectable_milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/selectable_progress_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class UploadProjectDetails extends GetView<UploadProjectDetailsController> {
  UploadProjectDetails({super.key});

  final audioController = Get.find<AudioRecorderController>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header with search icon
                WorkProgressHeader(
                  //title: controller.screenTitle,
                  title: "Work Detail",
                  subtitle: 'Track Progress of works in real-time',
                  avatarAssetPath: ImageAssets.emblemImage,
                  backIcon: Icons.arrow_back,
                  widget: Obx(() {
                    return controller.userProject != null
                        ? UrgentWorkDetailsInfoWidget(
                          project: controller.data.value,
                          status: controller.projectStatus.value,
                          userProject: controller.userProject ?? UserProject(),
                        )
                        : WorkDetailInfoWidget(
                          project: controller.data.value,
                          status: controller.projectStatus.value,
                        );
                  }),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.xl),

                      // Photo Upload Section
                      const TitleText(
                        text: 'Photos',
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Obx(
                        () => SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(3, (index) {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.30,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: PhotoUploadWidget(
                                  imagePath: controller.photos[index],
                                  onTap: () async {
                                    final insideGeofence = await controller
                                        .checkGeoFence(
                                          controller.data.value.lat ?? 0.0,
                                          controller.data.value.lng ?? 0.0,
                                        );
                                    debugPrint("1. After Gepfence");
                                    if (insideGeofence) {
                                      //controller.showPhotoSourceDialog(index);
                                      controller.takePhoto(index);
                                    } else {
                                      PopupMixin().showErrorDialog(
                                        Get.context!,
                                        message: "You are outside the location",
                                      );
                                    }
                                  },
                                  label: 'Tap to take a photo',
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppDimensions.lg),
                      // Project Overall Status Section
                      const TitleText(
                        text: 'Overall status',
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: AppDimensions.sm),

                      Obx(() {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SelectableProgressCard(
                                title: "Not Started",
                                onTap:
                                    () => controller.selectProgress(
                                      "Not Started",
                                    ),
                                isSelected:
                                    controller.selectedProgress.value ==
                                    "Not Started",
                              ),

                              const SizedBox(width: AppDimensions.s),

                              SelectableProgressCard(
                                title: "OnGoing",
                                onTap:
                                    () => controller.selectProgress(
                                      "In Progress",
                                    ),
                                isSelected:
                                    controller.selectedProgress.value ==
                                    "In Progress",
                              ),

                              const SizedBox(width: AppDimensions.s),

                              SelectableProgressCard(
                                title: "Completed",
                                onTap:
                                    () =>
                                        controller.selectProgress("Completed"),
                                isSelected:
                                    controller.selectedProgress.value ==
                                    "Completed",
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      Obx(() {
                        return controller.selectedProgress.value == "Completed"
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleText(
                                  text: 'Is this Project Functional?',
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: AppDimensions.sm),
                                FunctionalYesNoSelector(
                                  value: controller.isFunctionalProject.value,
                                  onChanged: (value) {
                                    controller.isFunctionalProject.value =
                                        value;
                                  },
                                ),
                              ],
                            )
                            : SizedBox.shrink();
                      }),

                      const SizedBox(height: 16),

                      // Project Overall Progress Section
                      const TitleText(
                        text: 'Project Progress',
                        fontWeight: FontWeight.w600,
                      ),
                      Obx(
                        () => ProgressSelector(
                          isLocked: controller.isLocked.value,
                          progress: controller.statusProgressValue.value,
                          onChanged: (value) {
                            controller.statusProgressValue.value = value;
                            if (controller.statusProgressValue.value == 100) {
                              controller.selectedProgress.value = "Completed";
                              controller.isLocked(true);
                            }
                            if (controller.statusProgressValue.value == 0) {
                              controller.selectedProgress.value = "Not Started";
                              controller.isLocked(true);
                            }
                          },
                        ),
                      ),

                      Obx(
                        () =>
                            controller.isFunctionalProject.value == true
                                ? Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    CapturedVideoPreview(
                                      videoPath: controller.displayedVideoPath,
                                      onCaptureTap: controller.onCaptureVideo,
                                      onRemoveTap:
                                          controller.clearVideoSelection,
                                      showRemoveButton:
                                          controller.isShowingApiVideoOnly ==
                                          false,
                                    ),
                                  ],
                                )
                                : SizedBox.shrink(),
                      ),

                      const SizedBox(height: AppDimensions.lg),

                      // Remarks Section
                      const TitleText(
                        text: 'Remarks',
                        fontWeight: FontWeight.w600,
                      ),

                      const SizedBox(height: 12),
                      RemarksInputWidget(
                        controller: controller.remarksController,
                        hintText: 'Add context or observations (optional)',
                        onMicrophoneTap: audioController.toggleRecording,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),

                      AudioRecorderWidget(),
                      const SizedBox(height: 100), // Space for submit button
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Footer with Submit Button
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // color: const Color(0xFF8B4513), // Brown color from screenshot
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: AuthSubmitButton(
              height: 44,
              title: controller.isSubmitting.value ? "Uploading..." : "Submit",
              isEnabled: !controller.isSubmitting.value,
              onPressed: () async {
                if (controller.isSubmitting.value) return;

                controller.isSubmitting.value = true;

                try {
                  await controller.submitData();
                } finally {
                  controller.isSubmitting.value = false;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
