
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  const HeaderText({super.key,required this.text,this.color=AppColors.textPrimary,this.textAlign=TextAlign.start,this.fontWeight=FontWeight.w700});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: Get.textTheme.headlineMedium?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontFamily: "Montserrat"
      ),
    );
  }
}
