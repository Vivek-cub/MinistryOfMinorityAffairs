import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/project_functional_questionnaire.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/capture_video_previews.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/function_toggle.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class ProjectFunctionalView extends GetView<ProjectFunctionalController> {
  const ProjectFunctionalView({super.key});

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
                WorkProgressHeader(
                  //title: controller.screenTitle,
                  title: "Project Details",
                  subtitle: 'Track Progress of works in real-time',
                  avatarAssetPath: ImageAssets.emblemImage,
                  backIcon: Icons.arrow_back,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          text: 'Is this Project Functional?',
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        FunctionalYesNoSelector(
                          value: controller.isFunctionalProject.value,
                          onChanged: controller.selectFunctionalProject,
                        ),
                        if (controller.isFunctionalProject.value == true) ...[
                          // const ProjectFunctionalQuestionnaire(),
                          const SizedBox(height: AppDimensions.lg),
                          CapturedVideoPreview(
                            videoPath: controller.displayedVideoPath,
                            onCaptureTap: controller.onCaptureVideo,
                            onRemoveTap: controller.clearVideoSelection,
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
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
            child: Obx(
              () => AuthSubmitButton(
                height: 44,
                title:
                    controller.isSubmitting.value ? 'Submitting...' : 'Submit',
                isEnabled: !controller.isSubmitting.value,
                onPressed:
                    controller.isSubmitting.value
                        ? null
                        : controller.submitData,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
