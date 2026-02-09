import 'package:get/get.dart';
import '../controllers/projects_list_controllers.dart';

/// Projects list binding
/// Initializes dependencies for projects list screen
class ProjectsListBinding extends Bindings {
  final String statusFilter;
  
  ProjectsListBinding({this.statusFilter = 'in_progress'});

  @override
  void dependencies() {
    // Get status from route arguments or use provided default
    String status = statusFilter;
    
    try {
      final args = Get.arguments;
      if (args != null && args is String) {
        status = args;
      }
    } catch (e) {
      // If arguments not available, use provided default
      status = statusFilter;
    }
    
    Get.lazyPut<ProjectsListControllers>(
      () => ProjectsListControllers(statusFilter: status),
    );
  }
}
