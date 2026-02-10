import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/capture_video_previews.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/local_video_player.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/selectable_milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/views/audio_recorder_widget.dart';
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
                          WorkDetailInfoWidget(project: controller.data.value),
                          const SizedBox(height: 24),

                          TitleText(text: "Milestones",),
                          Obx(() {
                                if (controller.milestones.isEmpty) {
                                  return const Center(child: Text("No milestones found"));
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.milestones.length,
                                  itemBuilder: (context, index) {
                                    final milestone = controller.milestones[index];
                                    return MilestoneCard(milestone: milestone,imageCount: milestone.imageAtt?.length??0,);
                                  },
                                );
                              }
                        ),
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
                                          ()async{
                                            final insideGeofence= await controller.checkGeoFence(controller.data.value.lat??0.0,controller.data.value.lng??0.0);
                                            if(insideGeofence==true){
                                              controller
                                              .showPhotoSourceDialog(index);
                                            }else{
                                              PopupMixin().showErrorDialog(context,message: "You are outside the loaction");
                                            }
                                          },
                                      label: 'Tap to take a photo',
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Obx(() {
                            return CapturedVideoPreview(
                              videoPath: controller.videoPath.value,
                              onCaptureTap: (){
                                controller.onCaptureVideo();
                              },
                              onRemoveTap: () {
                                controller.videoPath.value = "";
                              },
                            );
                          }),

                          const SizedBox(height: 24),
                          const Text(
                            'Select MileStones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          Obx(() {
                            return Column(
                              children: controller.milestones.map((milestone) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SelectableMilestoneCard(
                                    milestone: milestone,
                                    isSelected:
                                        controller.isSelected(milestone.id??""),
                                    onTap: () {
                                      controller.selectMilestone(milestone.id??"");
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
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
                            onMicrophoneTap: audioController.toggleRecording,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 12),

                          AudioRecorderWidget(),
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
