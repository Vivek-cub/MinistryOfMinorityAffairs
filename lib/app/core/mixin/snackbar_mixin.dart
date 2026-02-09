import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_navigation/src/snackbar/snackbar_controller.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

mixin class SnackBarMixin {
  SnackbarController showSnackBar({
    String? title,
    String? message,
    SnackPosition snackPosition = SnackPosition.TOP,
  }) {
    return Get.snackbar(
      title ?? 'Something went wrong',
      message ?? 'Please try again later',
      snackPosition: snackPosition,
      backgroundColor: Colors.white,
    );
  }

  Future<void>? showAlertCustom({
    bool barrierDismissible = true,
    bool backBtnDisable = false,
    String? title,
    double insetPadding = AppDimensions.sideIndicator2Height,
  }) {
    if (Get.context == null) return null;
    return showDialog(
      context: Get.context!,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          canPop: !backBtnDisable,
          child: AlertDialog(
            insetPadding: EdgeInsets.all(insetPadding),
            content: Column(
              spacing: AppDimensions.sm,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                  radius: 20.0,
                  color: AppColors.primary,
                ),
                Text(
                  title ?? "Submitting data...",
                  style: Get.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}