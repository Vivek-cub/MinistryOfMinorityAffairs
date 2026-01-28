import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/work_detail_controller.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';

/// Work Detail binding
/// Handles dependency injection for Work Detail screen
class WorkDetailBinding extends Bindings {
  @override
  void dependencies() {
    // Get project from arguments
    final arguments = Get.arguments;

    ProjectModel project;

    if (arguments == null || arguments is! ProjectModel) {
      // If arguments are invalid, show error and create a default project
      // This prevents the route from failing and redirecting to home
      print(
        '⚠️ WorkDetailBinding: Invalid or missing arguments. Type: ${arguments?.runtimeType}',
      );
      Get.snackbar(
        'Error',
        'Project data is missing. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Create a default project to prevent binding failure
      project = ProjectModel(
        id: '',
        title: 'Unknown Project',
        location: 'Unknown Location',
        status: 'in_progress',
        updatedAt: DateTime.now(),
        isGeotagged: false,
      );
    } else {
      project = arguments;
      print(
        '✅ WorkDetailBinding: Successfully received project: ${project.id}',
      );
    }

    // Use Get.put for immediate initialization
    Get.put(WorkDetailController(project: project));
  }
}
