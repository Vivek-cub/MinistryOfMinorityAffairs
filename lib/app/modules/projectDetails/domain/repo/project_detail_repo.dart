
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';

abstract class ProjectDetailRepo {
  Future<CommonResponseModel> uploadMilestoneFiles(
    {
      required String projectId,
      required String milestoneId,
      required List<String> imagePaths,
      String? videoPath,
      String? audioPath,
    }
  );
}