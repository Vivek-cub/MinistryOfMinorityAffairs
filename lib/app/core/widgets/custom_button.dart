import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  String? title;
  Color? color;
  final VoidCallback? onPressed;
  CustomButton({
    super.key,
    required this.title,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        decoration: BoxDecoration(
          color: color ?? AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppDimensions.xs),
        ),
        child: Text(
          title ?? "",
          textAlign: TextAlign.center,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          ),
        ),
      ),
    );
  }
}
