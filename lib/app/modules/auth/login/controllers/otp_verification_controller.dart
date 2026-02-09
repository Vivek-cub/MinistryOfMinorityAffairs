import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class OtpVerificationController extends GetxController with SnackBarMixin,PopupMixin{

  final SendMobileOtpRepo sendMobileOtpRepo;
  final AuthService authService;
  OtpVerificationController(this.sendMobileOtpRepo,this.authService);

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  final RxBool isButtonEnabled = false.obs;
  final RxString phoneNumber = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Get phone number from previous screen
    phoneNumber.value = Get.arguments['phoneNumber'] ?? '';
    
    // Add listeners to all OTP fields
    for (var controller in otpControllers) {
      controller.addListener(_validateOTP);
    }
  }
  
  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
  
  /// Validate OTP and enable/disable button
  void _validateOTP() {
    // Enable button if all 4 digits are filled
    bool allFilled = otpControllers.every((controller) => controller.text.isNotEmpty);
    isButtonEnabled.value = allFilled;
  }
  
  /// Handle text change in OTP field
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      // Move to next field
      focusNodes[index + 1].requestFocus();
    }
    _validateOTP();
  }
  
  /// Handle backspace in OTP field
  void onOtpBackspace(int index) {
    if (index > 0) {
      // Move to previous field
      focusNodes[index - 1].requestFocus();
    }
  }
  
  /// Get complete OTP
  String getOTP() {
    return otpControllers.map((controller) => controller.text).join();
  }
  
  /// Verify OTP
  void verifyOTP() async{
    if (!isButtonEnabled.value) return;
    String enteredOtp=getOTP();
    
try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Login..."
      );
      final modelData = await sendMobileOtpRepo.verifyOTP(mobileNo: phoneNumber.value,otp: enteredOtp);
      if (modelData?.data != null) {
        
        if (modelData?.statusCode == '200') {
        
          Get.back();
          await authService.onLogin(
            modelData?.data?.token ?? '',
          );
          final hasPin = await authService.checkPinFromStorage();
          
          Get.offNamed(hasPin ? AppRoutes.pinLogin : AppRoutes.setPin);
      
      }
      }else {
        showErrorDialog(Get.context!,
            title: "Error",
            message: modelData?.error ?? "Something went wrong.",
            onPressed: () async {
          Get.back();
        });
      }
    } catch (e) {
      Get.back();
      //debugPrint(e.toString());
    } finally {
      
    }
  }
  
  /// Resend OTP
  void resendOTP() {
    // TODO: Integrate with actual OTP resend API
    
    // Clear all OTP fields
    for (var controller in otpControllers) {
      controller.clear();
    }
    
    // Focus on first field
    focusNodes[0].requestFocus();
    
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
