
import 'package:dio/dio.dart';

import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class ProjectDetailRepoImpl extends ProjectDetailRepo with SnackBarMixin, PopupMixin{
  final ApiService apiService;
  ProjectDetailRepoImpl(this.apiService);
  @override
  Future<CommonResponseModel> uploadMilestoneFiles({
    required String projectId, 
    required String milestoneId, 
    required List<String> imagePaths, 
    String? videoPath,
    String? audioPath,
    })async {
    try {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('projectId', projectId),
      MapEntry('milestoneId', milestoneId),
    ]);

    // Multiple images
    for (final path in imagePaths) {
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(
            path,
            filename: path.split('/').last,
          ),
        ),
      );
    }

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
    if (audioPath != null && audioPath.isNotEmpty) {
      formData.files.add(
        MapEntry(
          'audio',
          await MultipartFile.fromFile(
            audioPath,
            filename: audioPath.split('/').last,
          ),
        ),
      );
    }


    final response = await apiService.post(
      NetworkConstants.uploadMilestoneFiles,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
    if(response.statusCode==200){
      return CommonResponseModel.fromJson(response.data);
    }else{
      return CommonResponseModel();
    }
    
  } catch (e) {
    rethrow;
  }
  }

}