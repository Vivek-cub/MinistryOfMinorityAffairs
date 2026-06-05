import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';

class SelectableProgressCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const SelectableProgressCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isSelected ? Colors.green : Colors.grey.shade300;

    final Gradient bgGradient =
        isSelected
            ? LinearGradient(
              colors: [AppColors.secondary, AppColors.secondaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
            : LinearGradient(
              colors: [Color(0xFFFFB84D), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: bgGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomText(text: title, color: AppColors.textWhite),
        ),
      ),
    );
  }
}
