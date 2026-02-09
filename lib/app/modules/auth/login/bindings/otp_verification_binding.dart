import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/controllers/otp_verification_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/repo/send_mobile_otp_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// OTP Verification Binding
/// Binds OtpVerificationController for dependency injection
class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(
        SendMobileOtpRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>()
      ),
    );
  }
}
