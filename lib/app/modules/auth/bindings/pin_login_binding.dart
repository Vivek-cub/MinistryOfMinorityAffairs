import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/pin_login_controller.dart';

/// PIN Login Binding
/// Initializes the PIN Login controller
class PinLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PinLoginController>(() => PinLoginController());
  }
}
