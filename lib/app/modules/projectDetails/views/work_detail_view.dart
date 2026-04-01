import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/capture_video_previews.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/selectable_milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/audio_recorder_widget.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import '../controller/work_detail_controller.dart';

/// Work Detail view
/// Displays work details and allows updating progress with photos and remarks
class WorkDetailView extends GetView<WorkDetailController> {
  WorkDetailView({super.key});
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
                  widget: WorkDetailInfoWidget(project: controller.data.value),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Work Detail Info
                      // const SizedBox(height: 24),
                      // TitleText(text: "Milestones"),
                      Obx(() {
                        if (controller.milestones.isEmpty) {
                          return const Center(
                            child: Text("No milestones found"),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.milestones.length,
                          itemBuilder: (context, index) {
                            final milestone = controller.milestones[index];
                            return MilestoneCard(
                              milestone: milestone,
                              imageCount: milestone.imageAtt?.length ?? 0,
                            );
                          },
                        );
                      }),
                      const SizedBox(height: 24),

                      Obx(() {
                        return controller.data.value.status != "Completed"
                            ? Text(
                              'Select MileStones',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            )
                            : SizedBox.shrink();
                      }),

                      Obx(() {
                        return Column(
                          children:
                              controller.milestones.map((milestone) {
                                return milestone.status != "Completed"
                                    ? Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: SelectableMilestoneCard(
                                        milestone: milestone,
                                        isSelected: controller.isSelected(
                                          milestone.id ?? "",
                                        ),
                                        onTap: () {
                                          controller.selectMilestone(
                                            milestone.id ?? "",
                                          );
                                          Get.toNamed(
                                            AppRoutes.uploadProjectDetails,
                                            arguments: {
                                              "project": controller.data.value,
                                              "milestoneId":
                                                  controller
                                                      .selectedMilestoneId
                                                      .value,
                                            },
                                          );
                                        },
                                      ),
                                    )
                                    : SizedBox.shrink();
                              }).toList(),
                        );
                      }),

                      const SizedBox(height: 24),

                      // Remarks Section
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Footer with Submit Button
      ),
    );
  }
}
