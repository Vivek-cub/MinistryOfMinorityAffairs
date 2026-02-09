import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Set PIN Controller
/// Handles PIN creation and validation
class SetPinController extends GetxController {
  final AuthService authService;
  
  final List<TextEditingController> pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  
  final List<FocusNode> focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  final RxBool isButtonEnabled = false.obs;
  final RxBool rememberPin = false.obs;
  final RxBool isPinVisible = false.obs;

  SetPinController(this.authService);
  
  @override
  void onInit() {
    super.onInit();
    
    // Add listeners to all PIN fields
    for (var controller in pinControllers) {
      controller.addListener(_validatePin);
    }
  }
  
  @override
  void onClose() {
    for (var controller in pinControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
  
  /// Validate PIN and enable/disable button
  void _validatePin() {
    // Enable button if all 4 digits are filled and checkbox is checked
    bool allFilled = pinControllers.every((controller) => controller.text.isNotEmpty);
    isButtonEnabled.value = allFilled && rememberPin.value;
  }
  
  /// Handle text change in PIN field
  void onPinChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      // Move to next field
      focusNodes[index + 1].requestFocus();
    }
    _validatePin();
  }
  
  /// Handle backspace in PIN field
  void onPinBackspace(int index) {
    if (index > 0) {
      // Move to previous field
      focusNodes[index - 1].requestFocus();
    }
  }
  
  /// Get complete PIN
  String getPin() {
    return pinControllers.map((controller) => controller.text).join();
  }
  
  /// Toggle remember PIN checkbox
  void toggleRememberPin(bool? value) {
    rememberPin.value = value ?? false;
    _validatePin();
  }
  
  /// Create and save PIN
  void createPin() {
    if (!isButtonEnabled.value) return;
    
    final pin = getPin();
    
    // Validate PIN
    if (pin.length != 4) {
      Get.snackbar(
        'Invalid PIN',
        'Please enter a 4-digit PIN',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
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
