import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';

/// Reusable status tag widget
/// Displays work status with a colored dot indicator
class StatusTag extends StatelessWidget {
  final String status;
  final Color? backgroundColor;
  final Color? dotColor;

  const StatusTag({
    super.key,
    required this.status,
    this.backgroundColor,
    this.dotColor,
  });

  String get _statusLabel {
    switch (status) {
      case 'in_progress':
        return 'Work In Progress';
      case 'not_started':
        return 'Not Started';
      case 'Completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  Color get _statusColor {
    switch (status) {
      case 'in_progress':
        return const Color(0xFFFFC107); // Yellow/Gold
      case 'not_started':
        return Colors.red;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color get _statusBgColor {
    switch (status) {
      case 'in_progress':
        return const Color(0xFFFFF9C4); // Light yellow background
      case 'not_started':
        return Colors.red.withOpacity(0.1);
      case 'completed':
        return Colors.green.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? _statusBgColor;
    final dotColorValue = dotColor ?? _statusColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColorValue,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
