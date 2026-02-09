import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

/// Reusable remarks input widget
/// Text input field with microphone icon for voice input
class RemarksInputWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final VoidCallback? onMicrophoneTap;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const RemarksInputWidget({
    super.key,
    this.controller,
    this.hintText,
    this.onMicrophoneTap,
    this.onChanged,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: maxLines ?? 5,
            decoration: InputDecoration(
              hintText: hintText ?? 'Add context or observations (optional)',
              hintStyle: TextStyle(
                color: AppColors.textHint,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 16, 40, 16),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          // Microphone icon positioned at bottom-right
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                Icons.mic_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              onPressed: onMicrophoneTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
