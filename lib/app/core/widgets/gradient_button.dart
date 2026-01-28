import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';

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
    final colors =
        gradientColors ??
        [
          AppColors.primaryLight,
          AppColors.primary,
          AppColors.primaryDark,
          Colors.redAccent,
        ];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Opacity(
            opacity: onPressed == null ? 0.6 : 1.0,
            child: Container(
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
