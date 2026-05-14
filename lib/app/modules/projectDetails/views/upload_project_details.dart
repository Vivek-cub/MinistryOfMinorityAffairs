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
import 'package:ministry_of_minority_affairs/app/core/widgets/work_detail_info_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/upload_project_details_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/audio_recorder_widget.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/capture_video_previews.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/project_selector.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/selectable_milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/selectable_progress_card.dart';
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
                  widget: WorkDetailInfoWidget(
                    project: controller.data.value,
                    status: controller.projectStatus.value,
                  ),
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

                                    if (insideGeofence) {
                                      controller.showPhotoSourceDialog(index);
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

                      /*
                      const SizedBox(height: AppDimensions.lg),

                      Obx(() {
                        if (!controller.isLastPendingMilestone) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleText(
                              text: 'Video',
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            CapturedVideoPreview(
                              videoPath: controller.videoPath.value,
                              onCaptureTap: controller.onCaptureVideo,
                              onRemoveTap: () {
                                controller.videoPath.value = "";
                              },
                            ),
                            const SizedBox(height: AppDimensions.lg),
                          ],
                        );
                      }),
                      */
                      const SizedBox(height: AppDimensions.lg),
                      // Project Overall Status Section
                      const TitleText(
                        text: 'Milestone overall status',
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Obx(() {
                        return SizedBox(
                          height: 50,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SelectableProgressCard(
                                title: "Not Started",
                                onTap:
                                    () =>
                                        controller.selectProgress("NotStarted"),
                                isSelected:
                                    controller.selectedProgress.value ==
                                    "NotStarted",
                              ),

                              const SizedBox(width: AppDimensions.s),

                              SelectableProgressCard(
                                title: "Work In Progress",
                                onTap:
                                    () => controller.selectProgress(
                                      "WorkInProgress",
                                    ),
                                isSelected:
                                    controller.selectedProgress.value ==
                                    "WorkInProgress",
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

                      const SizedBox(height: 12),

                      // Project Overall Progress Section
                      const TitleText(
                        text: 'Milestone Progress',
                        fontWeight: FontWeight.w600,
                      ),
                      Obx(
                        () => ProgressSelector(
                          progress: controller.statusProgressValue.value,
                          onChanged: (value) {
                            controller.statusProgressValue.value = value;
                          },
                        ),
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
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: AuthSubmitButton(
              height: 44,
              title: "Submit",
              isEnabled: true,
              // isEnabled: controller.isSubmitting.value,
              onPressed: () {
                controller.submitData();
              },
            ),
          ),
        ),
      ),
    );
  }
}
