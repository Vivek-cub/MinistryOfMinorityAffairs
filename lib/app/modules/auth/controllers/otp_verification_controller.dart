import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';

/// OTP Verification Controller
/// Handles OTP input validation and verification
class OtpVerificationController extends GetxController {
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
  void verifyOTP() {
    if (!isButtonEnabled.value) return;
    
    // TODO: Integrate with actual OTP verification API
    // final otp = getOTP();
    // Verify otp with API
    
    // Show success message
    Get.snackbar(
      'Success',
      'OTP verified successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Navigate to Set PIN screen after successful verification
    Get.offAllNamed(AppRoutes.setPin);
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
