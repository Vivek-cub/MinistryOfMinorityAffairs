import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/domain/repo/create_pin_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_notification_service.dart';

/// Set PIN Controller
/// Handles PIN creation and validation
class SetPinController extends GetxController with SnackBarMixin, PopupMixin {
  final AuthService authService;
  final CreatePinRepo createPinRepo;

  final RxBool rememberPin = false.obs;
  RxString otp = "".obs;
  final GlobalKey<MaskedOtpInternalState> otpKey =
      GlobalKey<MaskedOtpInternalState>();

  SetPinController(this.authService, this.createPinRepo);
  final RxString phoneNumber = ''.obs;
  RxBool isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments['phoneNumber'] ?? '';
  }

  /// Toggle remember PIN checkbox
  void toggleRememberPin(bool? value) {
    rememberPin.value = value ?? false;
    checkPinAndCheckbox(otp.value);
  }

  void checkPinAndCheckbox(String pin) {
    if (pin.length != 4) {
      return;
    }
    if (rememberPin.value == false) {
      return;
    }
    createPin(pin);
  }

  /// Create and save PIN
  void createPin(String pin) {
    if (pin.length != 4) {
      showErrorDialog(Get.context!, message: "Please enter a 4-digit PIN");
      return;
    }
    if (rememberPin.value == false) {
      showErrorDialog(Get.context!, message: "Please select all fields");
      return;
    }
    createPinApi(pin);
  }

  void createPinApi(String pinNo) async {
    // if (!isButtonEnabled.value) return;
    // String enteredOtp=getOTP();

    try {
      if (isVerifying.value) return;

      isVerifying.value = true;
      showAlertCustom(backBtnDisable: true, title: "Creating Pin...");
      final modelData = await createPinRepo.createPin(
        mobileNo: phoneNumber.value,
        pin: pinNo,
      );

      if (modelData?.statusCode == '200') {
        Get.back();
        Get.snackbar(
          'Success',
          'PIN created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        Get.offNamed(
          AppRoutes.pinLogin,
          arguments: {'phoneNumber': phoneNumber.value},
        );
      } else {
        otp.value = "";
        otpKey.currentState?.clear();
        Get.back();
      }
    } catch (e) {
      otp.value = "";
      otpKey.currentState?.clear();
      Get.back();
      //debugPrint(e.toString());
    } finally {
      isVerifying.value = false;
    }
  }
}
