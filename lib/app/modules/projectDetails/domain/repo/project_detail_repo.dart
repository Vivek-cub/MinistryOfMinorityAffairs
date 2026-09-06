import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/model/upload_resp_model.dart';

abstract class ProjectDetailRepo {
  Future<UploadResponse> uploadMilestoneFiles({
    required String projectId,
    required List<String> imagePaths,
    String? videoPath,
    String? audioPath,
    required String userLat,
    required String userLng,
    required String progress,
    required String projectStatus,
    required String remarks,
  });

  Future<UploadResponse> uploadMilestoneFilesForTesting({
    required String projectId,
    required List<String> imagePaths,
    String? videoPath,
    String? audioPath,
    required String userLat,
    required String userLng,
    required String progress,
    required String projectStatus,
    required String remarks,
  });
}
