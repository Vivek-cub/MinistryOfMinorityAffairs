import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Mobile Number Entry Controller
/// Handles mobile number input validation and navigation
class MobileNumberController extends GetxController with SnackBarMixin,PopupMixin{
  final SendMobileOtpRepo sendMobileOtpRepo;
  final AuthService authService;
  MobileNumberController(this.sendMobileOtpRepo,this.authService);

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
  void sendOTP(String mobileNo) async{
    if (!isButtonEnabled.value) return;
    
    final phoneNumber = phoneController.text.trim();
    
    try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Login..."
      );
      final modelData = await sendMobileOtpRepo.sendMobileOtp(mobileNo: mobileNo);
      
        
        if (modelData?.statusCode =="200") {
            Get.back();
            Get.toNamed(
              AppRoutes.otpVerification,
              arguments: {
                'phoneNumber': phoneNumber,
              },
            );
        }
    } catch (e) {
      Get.back();
     
    } finally {
      
    }
    
  }


}
