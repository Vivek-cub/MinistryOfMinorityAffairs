import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

mixin class PopupMixin {
  void showSuccessDialog(
    BuildContext context, {
    VoidCallback? onPressed,
    VoidCallback? onPressedOnCancel,
    String title = "",
    String message = "",
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon
                    Image.asset(
                      'assets/images/success.png',
                      height: AppDimensions.sideIndicator2Height,
                      width: AppDimensions.sideIndicator2Height,
                    ),

                    const SizedBox(height: 15),

                    // Title
                    HeaderText(
                      text: title,
                      color: AppColors.textPrimary,
                    ),

                    // Message
                    const SizedBox(height: 8),
                    TitleText(
                      text: message,
                      color: AppColors.textPrimary,
                      ),
                    
                    const SizedBox(height: 20),
                    AuthSubmitButton(
                      title: "OK",
                      isEnabled: true,
                      onPressed: () {
                        Navigator.pop(context);
                        onPressed?.call();
                      },
                    )
                    // Button
                  ],
                ),
              ),

              // Close Button (Top-Right)
              /*  Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context); 
                    onPressedOnCancel?.call(); // ✅ Call function if not null
                  },
                ),
              ), */
            ],
          ),
        );
      },
    );
  }

  void showMessageDialog(
    BuildContext context, {
    VoidCallback? onPressed,
    VoidCallback? onPressedOnCancel,
    String? title,
    String? message,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                
                padding:
                    const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: AppDimensions.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    HeaderText(
                      text: title??"",
                      color: AppColors.textPrimary,
                    ),

                    // Message
                    const SizedBox(height: 8),
                    TitleText(
                      text: message??"",
                      color: AppColors.textPrimary,
                      textAlign: TextAlign.center,
                      ),
                    
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 120,
                          child: AuthSubmitButton(
                      title: "OK",
                      isEnabled: true,
                      onPressed: () {
                        Navigator.pop(context);
                        onPressed?.call();
                      },
                    ),
                        ),
                    SizedBox(width: 8,),
                    SizedBox(
                      height: 40,
                      width: 120,
                      child: AuthSubmitButton(
                        title: "Cancel",
                        isEnabled: false,
                        onPressed: () {
                          Navigator.pop(context);
                          onPressedOnCancel?.call();
                        },
                      ),
                    )
                      ],
                    ),
                    // Button
                  ],
                ),
              ),

              // Close Button (Top-Right)
              /*  Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () {
                    Navigator.pop(context); 
                    onPressedOnCancel?.call(); // ✅ Call function if not null
                  },
                ),
              ), */
            ],
          ),
        );
      },
    );
  }

  void showErrorDialog(
    BuildContext context, {
    VoidCallback? onPressed,
    VoidCallback? onPressedOnCancel,
    String title = "Error",
    String message = "Something went wrong!.",
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success Icon
                    Image.asset(
                      IconAssets.error,
                      height: AppDimensions.sideIndicator2Height,
                      width: AppDimensions.sideIndicator2Height,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      title,
                      style: Get.textTheme.displaySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AuthSubmitButton(
                      title: "OK",
                      isEnabled: true,
                      onPressed: () {
                        Navigator.pop(context);
                        onPressed?.call();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCapturedPhotoDialog(
    BuildContext context,
    File image,
    VoidCallback onRetake,
    VoidCallback onSave, {
    String? message,
    Color? textColor,
    bool showSaveButton = true, // Control Save button visibility
    VoidCallback? onCancel, // Dynamic function on cancel
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    if (onCancel != null) {
                      onCancel(); // Call the dynamic function if provided
                    }
                    Navigator.of(dialogContext).pop(); // Close dialog
                  },
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.cover),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (message != null &&
                        message.isNotEmpty) // Show only if message exists
                      CustomText(
                      text: message??"",
                      color: AppColors.textPrimary,
                    ),

              
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // CustomBorderButton(
                        //   text: "Capture Again",
                        //   function: onRetake,
                        // ),
                        if (showSaveButton) // Conditionally show Save button
                          
                          AuthSubmitButton(
                      title: "Save",
                      isEnabled: true,
                      onPressed: () {
                        onSave();
                      },
                    )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
