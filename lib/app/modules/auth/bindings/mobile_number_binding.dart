import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/mobile_number_controller.dart';

/// Mobile Number Binding
/// Binds MobileNumberController for dependency injection
class MobileNumberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileNumberController>(
      () => MobileNumberController(),
    );
  }
}
