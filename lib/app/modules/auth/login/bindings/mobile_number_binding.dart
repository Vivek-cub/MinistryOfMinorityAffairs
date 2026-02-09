import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/controllers/mobile_number_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/repo/send_mobile_otp_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/domain/repo/send_mobile_otp_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Mobile Number Binding
/// Binds MobileNumberController for dependency injection
class MobileNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileNumberController>(
      () => MobileNumberController(
         SendMobileOtpRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>()
      ),
    );
  }
}
