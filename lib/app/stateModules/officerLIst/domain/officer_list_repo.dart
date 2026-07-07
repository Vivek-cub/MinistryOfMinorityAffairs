import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/data/officer_list_response_model.dart';

abstract class OfficerListRepo {
  Future<OfficerListResponseModel?> getOfficerList({required String field});
}
