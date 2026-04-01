
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/modules/pin/controller/check_old_pin_controller.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class CheckOldPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckOldPinController>(() => CheckOldPinController(
      Get.find<AuthService>(),
    ));
  }
}