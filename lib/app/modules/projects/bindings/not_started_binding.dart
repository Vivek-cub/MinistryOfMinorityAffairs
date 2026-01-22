import 'package:get/get.dart';
import '../controllers/not_started_controller.dart';

/// Not Started binding
/// Initializes dependencies for Not Started screen
class NotStartedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotStartedController>(
      () => NotStartedController(),
    );
  }
}
