import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/set_pin_controller.dart';

/// Set PIN Binding
/// Initializes the Set PIN controller
class SetPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetPinController>(() => SetPinController());
  }
}
