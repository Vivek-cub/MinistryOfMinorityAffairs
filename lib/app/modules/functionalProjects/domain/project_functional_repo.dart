import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';

abstract class ProjectFunctionalRepo {
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    String? videoPath,
  });
}
