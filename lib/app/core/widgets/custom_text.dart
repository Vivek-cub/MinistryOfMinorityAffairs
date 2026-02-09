import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../theme/theme_constants.dart';
import '../theme/typography.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  const CustomText({super.key,required this.text,this.color=AppColors.textPrimary,this.textAlign=TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppTextTheme.bodySmall1.copyWith(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
