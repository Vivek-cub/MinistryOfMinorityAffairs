import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';

class InfoText extends StatelessWidget {
  final String text;
  final Color? infoTextColor;
  const InfoText({super.key, required this.text, this.infoTextColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.xs,
        right: AppDimensions.xs,
        top: AppDimensions.xs,
      ),
      child: Text(
        text,
        style: AppTextTheme.bodyVSmall.copyWith(
          color: infoTextColor ?? AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
