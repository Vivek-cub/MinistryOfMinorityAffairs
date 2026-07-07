import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/sim_change_service.dart';
import 'package:flutter/material.dart';

/// Splash screen controller
/// Handles splash screen logic and navigation
class SplashController extends GetxController {
  late final AuthService authService;
  late final SimChangeService simChangeService;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();
    simChangeService = Get.find<SimChangeService>();

    Future.delayed(const Duration(seconds: 2), () async {
      await _navigateToNextScreen();
    });
  }

  /// Navigate to next screen after splash duration
  Future<void> _navigateToNextScreen() async {
    // final hasSim = await simChangeService.hasSimAvailable();
    // if (!hasSim) {
    //   _showNoSimDialog();
    //   return;
    // }

    // final simChanged = await simChangeService.hasSimChanged();
    // if (simChanged) {
    //   await authService.onLogout();
    //   await authService.clearPin();
    //   await simChangeService.storeCurrentAsBaseline();
    //   Get.snackbar(
    //     'Security Alert',
    //     'SIM change detected. Please login again.',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   Get.offAllNamed(AppRoutes.mobileNumber);
    //   return;
    // }

    if (authService.loggedIn) {
      final hasPin = await authService.checkPinFromStorage();

      if (hasPin) {
        final route = await authService.dashboardRoute();
        Get.offAllNamed(
          authService.isPinVerifiedForSession ? route : AppRoutes.pinLogin,
        );
      } else {
        Get.offAllNamed(AppRoutes.setPin);
      }
    } else {
      Get.offAllNamed(AppRoutes.mobileNumber);
    }
  }

  void _showNoSimDialog() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      AlertDialog(
        title: const Text('SIM Required'),
        content: const Text(
          'No SIM detected. Please insert/enable a SIM to use this application.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 300));
              await _navigateToNextScreen();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
