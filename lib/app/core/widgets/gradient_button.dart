import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';

/// Reusable gradient button widget
/// Used for "Update progress" button with orange-to-red gradient

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final List<Color>? gradientColors;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.padding,
    this.fontSize,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppButtonGradientColor.gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Opacity(
          opacity: onPressed == null ? 0.6 : 1.0,
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: CustomText(text: text, color: AppColors.textWhite),
          ),
        ),
      ),
    );
  }
}
