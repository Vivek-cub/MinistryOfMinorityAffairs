import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/model/questionaire_data_model.dart';

abstract class ProjectFunctionalRepo {
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    //Map<String, dynamic> formValues = const {},
    String? videoPath,
  });

  Future<Map<String, dynamic>?> getQuestionaire({required String unitId});
  Future<CommonResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
  });
}
