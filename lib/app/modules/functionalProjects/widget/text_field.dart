import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/info_text.dart';

class MyFormBuilderTextField extends StatelessWidget {
  const MyFormBuilderTextField({
    super.key,
    required this.name,
    required this.label,
    this.keyboardType,
    this.disable = false,
    this.onChanged,
    this.helperMessages,
    this.validator,
    this.initialValue,
    this.maxValue,
    this.required,
    this.isShowNoteMsg,
    this.infoMsg,
    this.maxLength,
    // required String? Function(dynamic value) validator,
  });
  final String name;
  final String label;
  final String? initialValue;
  final bool disable;
  final Function(String?)? onChanged;
  final List<String>? helperMessages;
  final String? Function(String?)? validator;
  final String? keyboardType;
  final int? maxValue;
  final bool? required;
  final bool? isShowNoteMsg;
  final String? infoMsg;
  final int? maxLength;

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
          isShowNoteMsg == true
              ? SizedBox.shrink()
              : RichText(
                text: TextSpan(
                  text: label ?? "",
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
              ).paddingOnly(bottom: AppDimensions.xs),
          FormBuilderTextField(
            name: name,
            readOnly: disable,
            keyboardType:
                keyboardType == "number"
                    ? TextInputType.number
                    : TextInputType.text,
            maxLines: null,

            initialValue: initialValue,
            validator: validator,
            maxLength: maxLength,

            onChanged:
                onChanged != null
                    ? (value) {
                      onChanged!(value);
                    }
                    : null,
            style: Get.textTheme.titleSmall?.copyWith(
              color:
                  isShowNoteMsg == true
                      ? AppColors.error
                      : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: _getInputFormatters(),
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  disable == true ? AppColors.lightGrey : AppColors.textWhite,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color:
                      disable == true
                          ? AppColors.lightGrey
                          : AppColors.newPrimaryLight,
                  width: 1.5,
                ), // Remove default border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color:
                      disable == true
                          ? AppColors.lightGrey
                          : AppColors.newPrimaryLight,
                  width: 1.5,
                ), // Optional: Custom border when focused
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color: AppColors.error,
                  width: 1.5,
                ), // Optional: Custom border when focused
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide(
                  color:
                      disable == true
                          ? AppColors.lightGrey
                          : AppColors.newPrimaryLight,
                  width: 1.5,
                ), // Optional: Custom border when focused
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.xs),
                borderSide: BorderSide.none, // No border when disabled
              ),
            ),
          ),
          infoMsg != null ? InfoText(text: infoMsg ?? "") : SizedBox.shrink(),
          if (helperMessages != null && helperMessages!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  helperMessages!.map((message) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message,
                        style: AppTextTheme.bodyVSmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  List<TextInputFormatter>? _getInputFormatters() {
    if (keyboardType == "number") {
      if (maxValue != null && maxValue! <= 10) {
        // CGPA-style input: e.g., 9.99 or 10
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
        ];
      } else if (maxValue != null && maxValue! <= 100) {
        // Percentage-style input: e.g., 99.99 or 100
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
        ];
      }
    }
    return null;
  }
}
