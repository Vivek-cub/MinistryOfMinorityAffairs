import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/constants/app_constants.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';

/// Splash screen controller
/// Handles splash screen logic and navigation
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2), () {
      _navigateToNextScreen();
    });
  }

  /// Navigate to next screen after splash duration
  _navigateToNextScreen() {
    // Check if user is first time or logged in
    // For now, navigate to mobile number entry screen
    Get.offAllNamed(AppRoutes.mobileNumber);

    // Example logic for checking first time user:
    // final storageService = Get.find<StorageService>();
    // final isFirstTime = storageService.getBool(AppConstants.storageKeyFirstTime) ?? true;
    //
    // if (isFirstTime) {
    //   Get.offAllNamed(AppRoutes.onboarding);
    // } else {
    //   final token = storageService.getString(AppConstants.storageKeyToken);
    //   if (token != null && token.isNotEmpty) {
    //     Get.offAllNamed(AppRoutes.dashboard);
    //   } else {
    //     Get.offAllNamed(AppRoutes.mobileNumber);
    //   }
    // }
  }
}
