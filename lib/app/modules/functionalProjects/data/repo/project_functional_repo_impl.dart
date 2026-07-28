import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart'
    hide FormData;
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class ProjectFunctionalRepoImpl extends ProjectFunctionalRepo {
  final ApiService apiService;
  ProjectFunctionalRepoImpl(this.apiService);
  @override
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    String? videoPath,
  }) async {
    try {
      //final formData = FormData();
      final formData = FormData.fromMap({
        'projectId': projectId,
        'isFunctional': isFunctional,
      });
      // formData.fields.addAll([
      //   MapEntry('projectId', projectId),
      //   MapEntry('isFunctional', isFunctional),
      // ]);

      // Optional video
      if (videoPath != null && videoPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'video',
            await MultipartFile.fromFile(
              videoPath,
              filename: videoPath.split('/').last,
            ),
          ),
        );
      }

      final response = await apiService.post(
        NetworkConstants.updateFunctionality,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } catch (e) {
      rethrow;
    }
  }
}
