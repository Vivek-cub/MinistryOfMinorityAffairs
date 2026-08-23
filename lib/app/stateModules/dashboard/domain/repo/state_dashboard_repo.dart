import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/data/model/state_dashboard_response_model.dart';

abstract class StateDashboardRepo {
  Future<StateDashboardResponseModel?> getStateDashboardData();
  Future<ProjectResponse?> getNonWorkingOfficerList();
  Future<CommonResponseModel?> uploadProfileImage({required String image});
  Future<List<int>?> exportAssignedProjects({required String userId});
}
