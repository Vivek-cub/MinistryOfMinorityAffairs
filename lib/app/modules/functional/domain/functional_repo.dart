import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/submit_response_model.dart';

abstract class FunctionalRepo {
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    //Map<String, dynamic> formValues = const {},
    String? videoPath,
  });

  Future<FunctionalResponseModel> getQuestionaire({
    required String unitId,
    required String sectorId,
  });
  Future<SubmitResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
    required List<Map<String, dynamic>> media,
  });
}
