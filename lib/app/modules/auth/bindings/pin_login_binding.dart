import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/pin_login_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/data/repo/create_pin_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// PIN Login Binding
/// Initializes the PIN Login controller
class PinLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinLoginController>(
      () => PinLoginController(
        Get.find<AuthService>(),
        CreatePinRepoImpl(Get.find<ApiService>()),
      ),
    );
  }
}
