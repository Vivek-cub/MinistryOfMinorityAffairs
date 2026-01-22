import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/base_projects_controller.dart';

/// Work In Progress controller
/// Handles business logic for Work In Progress screen
class WorkInProgressController extends BaseProjectsController {
  @override
  String get statusFilter => 'in_progress';

  @override
  String get screenTitle => 'Work In Progress';

  @override
  Future<List<ProjectModel>> fetchProjectsFromAPI() async {
    // TODO: Replace with actual API call
    // Example:
    // final apiService = Get.find<ApiService>();
    // final response = await apiService.get('/projects?status=in_progress');
    // return (response.data as List)
    //     .map((json) => ProjectModel.fromJson(json))
    //     .toList();
    
    // For now, use static data
    return super.loadStaticData();
  }
}
