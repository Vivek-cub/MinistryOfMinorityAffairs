import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

/// PIN Login Controller
/// Handles PIN verification for quick login
class PinLoginController extends GetxController {

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
  final RxBool isPinVisible = false.obs;

  PinLoginController(this.authService);
  
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
    // Enable button if all 4 digits are filled
    bool allFilled = pinControllers.every((controller) => controller.text.isNotEmpty);
    isButtonEnabled.value = allFilled;
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
  
  /// Verify PIN and login
  void login() async{
    if (!isButtonEnabled.value) return;
    
    final enteredPin = getPin();
    
    // Validate PIN
    if (enteredPin.length != 4) {
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
    final isMatched = await authService.isPinMatched(enteredPin);

    // Verify PIN with stored PIN
    if (isMatched==true) {
      // PIN is correct - navigate to home screen
      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Navigate to home screen
      Get.back();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(AppRoutes.home);
      });
    } else {
      // PIN is incorrect
      Get.snackbar(
        'Incorrect PIN',
        'The PIN you entered is incorrect. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      // Clear all PIN fields
      for (var controller in pinControllers) {
        controller.clear();
      }
      
      // Focus on first field
      focusNodes[0].requestFocus();
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
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // Clear PIN from storage
              
              // Navigate back to mobile number screen
              Get.offAllNamed(AppRoutes.mobileNumber);
            },
            child: const Text('Reset PIN'),
          ),
        ],
      ),
    );
  }
}
