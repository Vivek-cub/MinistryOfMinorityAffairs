import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class UpdateService {
  UpdateService._();

  static final Upgrader upgrader = Upgrader(
    debugLogging: true,
    // debugDisplayAlways: true,

    // For testing only. Remove in production.
    // debugDisplayAlways: true,
    durationUntilAlertAgain: const Duration(seconds: 0),
  );

  static Widget build({required Widget child}) {
    return UpgradeAlert(
      upgrader: upgrader,

      // Force update
      barrierDismissible: false,
      showIgnore: false,
      showLater: false,

      child: child,
    );
  }
}
