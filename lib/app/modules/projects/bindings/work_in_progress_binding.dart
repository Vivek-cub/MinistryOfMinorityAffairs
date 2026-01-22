import 'package:get/get.dart';
import '../controllers/work_in_progress_controller.dart';

/// Work In Progress binding
/// Initializes dependencies for Work In Progress screen
class WorkInProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkInProgressController>(
      () => WorkInProgressController(),
    );
  }
}
