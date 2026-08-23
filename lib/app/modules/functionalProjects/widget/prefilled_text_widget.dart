import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/form_body_small.dart';

class PrefilledTextWidget extends StatelessWidget {
  final String text;
  final String? name;
  const PrefilledTextWidget({super.key, required this.text, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: AppDimensions.xs),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(AppDimensions.sm),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: FormBodySmall(text: text),
    );
  }
}
