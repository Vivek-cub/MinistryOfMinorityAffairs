import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Set PIN Controller
/// Handles PIN creation and validation
class SetPinController extends GetxController with PopupMixin{
  final AuthService authService;
  
  
  final RxBool rememberPin = false.obs;
  RxString otp="".obs;

  SetPinController(this.authService);
    
  /// Toggle remember PIN checkbox
  void toggleRememberPin(bool? value) {
    rememberPin.value = value ?? false;
    createPin(otp.value);
  }
  
  /// Create and save PIN
  void createPin(String pin) {
   
    if (pin.length != 4) {
      showErrorDialog(Get.context!,message: "Please enter a 4-digit PIN");
      return;
    }
    if(rememberPin.value==false){
      showErrorDialog(Get.context!,message: "Please select all fields");
      return;
    }

    authService.setPin(pin);
    Get.snackbar(
      'Success',
      'PIN created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
        Get.offNamed(AppRoutes.pinLogin);
  }
}
