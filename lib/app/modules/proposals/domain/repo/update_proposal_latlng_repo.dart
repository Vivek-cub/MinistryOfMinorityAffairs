import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/data/model/proposal_list_model.dart';

abstract class UpdateProposalLatlngRepo {
  Future<CommonResponseModel?> updateProposalLatlng({
    required String projectId,
    required String lat,
    required String lng,
  });
}
