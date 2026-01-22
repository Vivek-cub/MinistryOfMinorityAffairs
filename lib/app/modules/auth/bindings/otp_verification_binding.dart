import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/otp_verification_controller.dart';

/// OTP Verification Binding
/// Binds OtpVerificationController for dependency injection
class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(),
    );
  }
}
