import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Splash screen controller
/// Handles splash screen logic and navigation
class SplashController extends GetxController {
  late final AuthService authService;

  @override
  void onInit() {
    super.onInit();
    authService = Get.find<AuthService>();

    Future.delayed(const Duration(seconds: 2), () async {
      await _navigateToNextScreen();
    });
  }

  /// Navigate to next screen after splash duration
  Future<void> _navigateToNextScreen() async {
    if (authService.loggedIn) {
      final hasPin = await authService.checkPinFromStorage();

      if (hasPin) {
        Get.offAllNamed(AppRoutes.pinLogin);
      } else {
        Get.offAllNamed(AppRoutes.setPin);
      }
    }
    else {
      Get.offAllNamed(AppRoutes.mobileNumber);
    }
  }
}
