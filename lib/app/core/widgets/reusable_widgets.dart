import 'package:flutter/material.dart';

/// Reusable widgets and utility functions for common UI components
class ReusableWidgets {
  ReusableWidgets._();

  /// Get adaptive top padding based on device notch
  /// Returns 0 if top padding is greater than 24 (devices with notch)
  /// Returns 20 if top padding is 24 or less (devices without notch)
  static double getAdaptiveTopPadding(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return topPadding > 24 ? 0 : 20;
  }
}
