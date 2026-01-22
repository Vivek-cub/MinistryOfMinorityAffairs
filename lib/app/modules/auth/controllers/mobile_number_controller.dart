import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';

/// Mobile Number Entry Controller
/// Handles mobile number input validation and navigation
class MobileNumberController extends GetxController {
  final phoneController = TextEditingController();
  final RxBool isButtonEnabled = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validatePhoneNumber);
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
  
  /// Validate phone number and enable/disable button
  void _validatePhoneNumber() {
    final phone = phoneController.text.trim();
    // Enable button if phone number is 10 digits
    isButtonEnabled.value = phone.length == 10 && _isNumeric(phone);
  }
  
  /// Check if string contains only numbers
  bool _isNumeric(String str) {
    return RegExp(r'^[0-9]+$').hasMatch(str);
  }
  
  /// Send OTP and navigate to OTP screen
  void sendOTP() {
    if (!isButtonEnabled.value) return;
    
    final phoneNumber = '+91${phoneController.text.trim()}';
    
    // TODO: Integrate with actual OTP API
    // For now, just navigate to OTP screen
    
    // Navigate to OTP screen with phone number
    Get.toNamed(AppRoutes.otpVerification, arguments: {
      'phoneNumber': phoneNumber,
    });
  }
}
