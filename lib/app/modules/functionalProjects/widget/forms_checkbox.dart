import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';
import 'package:readmore/readmore.dart';

class FormsCheckbox extends StatelessWidget {
  final String text;
  final String name;
  final FormFieldValidator<bool>? validator;
  final bool? initialValue;
  const FormsCheckbox({
    super.key,
    required this.text,
    required this.name,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckbox(
      name: name,
      activeColor: AppColors.newPrimary,
      validator: validator,
      initialValue: initialValue,
      enabled: initialValue == true ? false : true ?? true,
      title: ReadMoreText(
        text,
        isExpandable: true,
        trimMode: TrimMode.Line,
        trimLines: 3,
        trimCollapsedText: "Read More",
        trimExpandedText: '.  Read More',
        style: AppTextTheme.bodySmall1.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
