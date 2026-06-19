import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/repo/state_dashboard_repo.dart';

class StateDashboardRepoImpl extends StateDashboardRepo {
  @override
  Future<ProjectResponse?> getNonWorkingOfficerList() {
    // TODO: implement getNonWorkingOfficerList
    throw UnimplementedError();
  }

  @override
  Future<HomeRespModel?> getStateDashboardData() {
    // TODO: implement getStateDashboardData
    throw UnimplementedError();
  }

  @override
  Future<CommonResponseModel?> uploadProfileImage({required String image}) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }
}
