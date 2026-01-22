import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/base_projects_controller.dart';

/// Completed Projects controller
/// Handles business logic for Completed Projects screen
class CompletedProjectsController extends BaseProjectsController {
  @override
  String get statusFilter => 'completed';

  @override
  String get screenTitle => 'Completed Tasks';

  @override
  Future<List<ProjectModel>> fetchProjectsFromAPI() async {
    // TODO: Replace with actual API call
    // Example:
    // final apiService = Get.find<ApiService>();
    // final response = await apiService.get('/projects?status=completed');
    // return (response.data as List)
    //     .map((json) => ProjectModel.fromJson(json))
    //     .toList();
    
    // For now, use static data
    return super.loadStaticData();
  }
}
