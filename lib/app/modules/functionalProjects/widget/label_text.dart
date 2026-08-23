import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

import 'info_text.dart';

class MyLabelText extends StatelessWidget {
  const MyLabelText({
    super.key,
    required this.label,
    this.infoMsg,
    this.required,
    this.infoMsgColor,
  });
  final String label;
  final String? infoMsg;
  final bool? required;
  final String? infoMsgColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.xs,
        horizontal: AppDimensions.xxs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != ""
              ? RichText(
                text: TextSpan(
                  text: label,
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color:
                        Get
                            .textTheme
                            .bodySmall
                            ?.color, // Important: manually set color
                  ),
                  children: [
                    TextSpan(
                      text: required == true ? ' *' : '',
                      style: Get.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.error, // Important: manually set color
                      ),
                    ),
                  ],
                ),
              ).paddingOnly(bottom: AppDimensions.xs)
              : SizedBox.shrink(),
          infoMsg != null
              ? InfoText(
                text: infoMsg ?? "",
                infoTextColor:
                    infoMsgColor == "greyColor" ? AppColors.lightGrey : null,
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
