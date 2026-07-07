import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class OtpVerificationController extends GetxController
    with SnackBarMixin, PopupMixin {
  final SendMobileOtpRepo sendMobileOtpRepo;
  final AuthService authService;
  OtpVerificationController(this.sendMobileOtpRepo, this.authService);

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  final RxBool isButtonEnabled = false.obs;
  final RxString phoneNumber = ''.obs;
  RxBool isVerifying = false.obs;
  RxString otp = "".obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments['phoneNumber'] ?? '';
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Verify OTP
  void verifyOTP(String otp) async {
    // if (!isButtonEnabled.value) return;
    // String enteredOtp=getOTP();
    if (otp.length != 4) {
      showErrorDialog(Get.context!, message: "Please fill correct otp");
    }

    try {
      if (isVerifying.value) return;

      isVerifying.value = true;
      showAlertCustom(backBtnDisable: true, title: "Login...");
      final modelData = await sendMobileOtpRepo.verifyOTP(
        mobileNo: phoneNumber.value,
        otp: otp,
      );

      if (modelData?.statusCode == '200') {
        Get.back();
        await authService.onLogin(modelData?.data?.token ?? '');
        final role =
            modelData?.data?.user?.role?.label ??
            modelData?.data?.user?.role?.name ??
            '';
        if (role.isNotEmpty) {
          await authService.setUserRole(role);
        }
        final hasPin = await authService.checkPinFromStorage();

        Get.offNamed(hasPin ? AppRoutes.pinLogin : AppRoutes.setPin);
      }
    } catch (e) {
      Get.back();
      //debugPrint(e.toString());
    } finally {
      isVerifying.value = false;
    }
  }

  /// Resend OTP
  void resendOTP() {
    // TODO: Integrate with actual OTP resend API

    // Clear all OTP fields
    // for (var controller in otpControllers) {
    //   controller.clear();
    // }

    // // Focus on first field
    // focusNodes[0].requestFocus();

    // Show success message
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to ${phoneNumber.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
