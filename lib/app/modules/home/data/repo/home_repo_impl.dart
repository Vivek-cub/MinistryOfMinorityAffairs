import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart'
    hide FormData;
import 'package:get/get_connect/http/src/multipart/multipart_file.dart'
    hide MultipartFile;
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class HomeRepoImpl extends HomeRepo with PopupMixin, SnackBarMixin {
  final ApiService apiService;
  HomeRepoImpl(this.apiService);

  @override
  Future<HomeRespModel?> getHomeData() async {
    try {
      final resp = await apiService.get(NetworkConstants.dashboard);
      if (resp.statusCode == HttpStatus.ok) {
        return HomeRespModel.fromJson(resp.data);
      } else {
        HomeRespModel modelData = HomeRespModel();
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.statusMessage ?? "Something Went Wrong",
        );
        return modelData;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<ProjectResponse?> getAssignedProjects() async {
    try {
      final resp = await apiService.get(NetworkConstants.assignedProjectList);
      if (resp.statusCode == HttpStatus.ok) {
        return ProjectResponse.fromJson(resp.data);
      } else {
        ProjectResponse modelData = ProjectResponse();
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.statusMessage ?? "Something Went Wrong",
        );
        return modelData;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<CommonResponseModel?> uploadProfileImage({
    required String image,
  }) async {
    try {
      final formData = FormData();

      formData.files.add(
        MapEntry(
          'profilePic',
          await MultipartFile.fromFile(image, filename: image.split('/').last),
        ),
      );

      final response = await apiService.post(
        NetworkConstants.uploadProfileImage,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
