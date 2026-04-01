import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../theme/theme_constants.dart';
import '../theme/typography.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final int maxLines;
  const CustomText({super.key,required this.text,this.color=AppColors.textPrimary,this.textAlign=TextAlign.start,this.fontWeight=FontWeight.w500,this.maxLines=1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Get.textTheme.bodySmall?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontFamily: "Montserrat"
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
