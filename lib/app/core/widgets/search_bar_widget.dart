import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/typography.dart';

/// Reusable search bar widget
/// Rounded search input field with magnifying glass icon
class SearchBarWidget extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const SearchBarWidget({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        onChanged: onChanged,

        onTap: onTap,
        style: Get.textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.normal,
          fontFamily: "Montserrat",
        ),
        decoration: InputDecoration(
          hintText: hintText ?? 'Search',
          hintStyle: Get.textTheme.bodySmall?.copyWith(
            color: AppColors.textHint,
            fontWeight: FontWeight.normal,
            fontFamily: "Montserrat",
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary,
            size: 24,
          ),
          filled: true,
          fillColor: AppColors.textWhite,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textHint),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textHint),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.textHint),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
