import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

class AuthSubmitButton extends StatelessWidget {
  final String title;
  bool isEnabled;
  VoidCallback? onPressed;
  double height;
  bool isAuthButton;
  AuthSubmitButton({
    super.key,
    required this.title,
    this.isEnabled = false,
    this.onPressed,
    this.height = 56,
    this.isAuthButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      // margin: EdgeInsets.symmetric(horizontal: AppDimensions.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isAuthButton == false ? AppGradientColor.gradient : null,
          color: isAuthButton == false ? null : AppColors.textWhite,
          borderRadius: BorderRadius.circular(AppDimensions.xxs),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          isAuthButton
                              ? AppColors.textPrimary
                              : AppColors.textWhite,
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
