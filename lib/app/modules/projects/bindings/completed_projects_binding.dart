import 'package:get/get.dart';
import '../controllers/completed_projects_controller.dart';

/// Completed Projects binding
/// Initializes dependencies for Completed Projects screen
class CompletedProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletedProjectsController>(
      () => CompletedProjectsController(),
    );
  }
}
