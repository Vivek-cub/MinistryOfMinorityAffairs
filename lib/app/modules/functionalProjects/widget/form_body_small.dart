import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

class FormBodySmall extends StatelessWidget {
  final String text;
  const FormBodySmall({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Get.textTheme.bodySmall?.copyWith(
        color: AppColors.primaryLight,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
