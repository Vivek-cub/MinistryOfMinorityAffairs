
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';

abstract class HomeRepo {
  Future<HomeRespModel?> getHomeData();
  Future<ProjectResponse?> getAssignedProjects();
  Future<CommonResponseModel?> uploadProfileImage({required String image} );
  
}