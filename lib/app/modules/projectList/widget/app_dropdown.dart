import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const AppDropdown({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Get.textTheme.bodySmall?.copyWith(
          color: AppColors.textHint,
          fontWeight: FontWeight.normal,
          fontFamily: "Montserrat",
        ),
        fillColor: AppColors.textWhite,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items:
          items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: CustomText(
                text: itemLabel(item),
                color: AppColors.textPrimary,
              ),
            );
          }).toList(),
      onChanged: onChanged,
    );
  }
}
