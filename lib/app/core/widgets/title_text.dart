import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

class TitleText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  const TitleText({super.key,required this.text,this.color=AppColors.textPrimary,this.textAlign=TextAlign.start,this.fontWeight=FontWeight.w500});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Get.textTheme.headlineSmall?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontFamily: "Montserrat"
      ),
    );
  }
}
