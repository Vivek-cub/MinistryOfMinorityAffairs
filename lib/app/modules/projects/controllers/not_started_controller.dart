import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/base_projects_controller.dart';

/// Not Started controller
/// Handles business logic for Not Started screen
class NotStartedController extends BaseProjectsController {
  @override
  String get statusFilter => 'not_started';

  @override
  String get screenTitle => 'Not Started';

  @override
  Future<List<ProjectModel>> fetchProjectsFromAPI() async {
    // TODO: Replace with actual API call
    // Example:
    // final apiService = Get.find<ApiService>();
    // final response = await apiService.get('/projects?status=not_started');
    // return (response.data as List)
    //     .map((json) => ProjectModel.fromJson(json))
    //     .toList();
    
    // For now, use static data
    return super.loadStaticData();
  }
}
