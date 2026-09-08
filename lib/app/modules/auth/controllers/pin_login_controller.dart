import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class PinLoginController extends GetxController with PopupMixin {
  final AuthService authService;
  PinLoginController(this.authService);
  RxString pin = "".obs;
  final GlobalKey<MaskedOtpInternalState> otpKey =
      GlobalKey<MaskedOtpInternalState>();

  void login(String pinNo) async {
    if (pinNo.length != 4) {
      showErrorDialog(Get.context!, message: "Please enter a 4-digit PIN");
      return;
    }
    final isMatched = await authService.isPinMatched(pinNo);
    // Verify PIN with stored PIN
    if (isMatched == true) {
      authService.markPinVerifiedForSession();
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get.offNamed(await authService.dashboardRoute());
      });
    } else {
      pin.value = "";

      otpKey.currentState?.clear();
      showErrorDialog(
        Get.context!,
        message: "The PIN you entered is incorrect. Please try again.",
      );
    }
  }

  /// Handle forgot PIN
  void forgotPin() {
    Get.dialog(
      AlertDialog(
        title: const Text('Forgot PIN?'),
        content: const Text(
          'To reset your PIN, you need to verify your mobile number again.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed(AppRoutes.mobileNumber);
            },
            child: const Text('Reset PIN'),
          ),
        ],
      ),
    );
  }
}
