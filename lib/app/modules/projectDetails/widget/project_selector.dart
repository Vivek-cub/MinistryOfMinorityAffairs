import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';

class ProgressSelector extends StatelessWidget {
  final int progress;
  final Function(int)? onChanged;
  final bool isLocked;
  const ProgressSelector({
    super.key,
    required this.progress,
    required this.onChanged,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(text: "${progress.toInt()}%"),
        Slider(
          value: progress.toDouble(),
          padding: EdgeInsets.all(8),
          activeColor: AppColors.success,
          min: 0,
          max: 100,
          divisions: 10,
          label: "${progress.toInt()}%",
          onChanged: (value) {
            if (isLocked) return;

            if (onChanged != null) {
              onChanged!(value.toInt());
            }
          },
        ),
      ],
    );
  }
}
