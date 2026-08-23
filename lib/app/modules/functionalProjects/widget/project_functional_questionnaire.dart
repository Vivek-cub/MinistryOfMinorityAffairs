import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/function_toggle.dart';

class ProjectFunctionalQuestionnaire
    extends GetView<ProjectFunctionalController> {
  const ProjectFunctionalQuestionnaire({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.lg),
        const TitleText(
          text: 'Timeline of Project',
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: AppDimensions.sm),
        _TimelineInput(controller: controller.timelineController),
        const SizedBox(height: AppDimensions.lg),
        Obx(
          () => _PercentageQuestion(
            value: controller.finishedPercentage.value,
            onChanged: controller.updateFinishedPercentage,
          ),
        ),
        const SizedBox(height: AppDimensions.lg),
        Obx(
          () => _StillWorkingQuestion(
            value: controller.stillWorkingOnProject.value,
            onChanged:
                (value) => controller.stillWorkingOnProject.value = value,
            isFunctional: controller.isFunctional.value,
          ),
        ),
      ],
    );
  }
}

class _TimelineInput extends StatelessWidget {
  const _TimelineInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter project timeline',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.newPrimary),
        ),
      ),
    );
  }
}

class _PercentageQuestion extends StatelessWidget {
  const _PercentageQuestion({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: 'What percentage of this is finished? ($value%)',
          fontWeight: FontWeight.w600,
          maxLines: 2,
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 100,
          divisions: 20,
          label: '$value%',
          activeColor: AppColors.success,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

class _StillWorkingQuestion extends StatelessWidget {
  const _StillWorkingQuestion({
    required this.value,
    required this.onChanged,
    required this.isFunctional,
  });

  final bool? value;
  final bool? isFunctional;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleText(
          text: 'Are we still working on this project?',
          fontWeight: FontWeight.w600,
          maxLines: 2,
        ),
        const SizedBox(height: AppDimensions.sm),
        FunctionalYesNoSelector(
          value: value,
          onChanged: onChanged,
          isFunctional: isFunctional,
        ),
      ],
    );
  }
}
