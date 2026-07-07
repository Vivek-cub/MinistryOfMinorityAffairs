import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/data/officer_list_response_model.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/domain/officer_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class OfficerListRepoImpl extends OfficerListRepo
    with SnackBarMixin, PopupMixin {
  final ApiService apiService;
  OfficerListRepoImpl(this.apiService);
  @override
  Future<OfficerListResponseModel?> getOfficerList({
    required String field,
  }) async {
    try {
      final resp = await apiService.get(
        NetworkConstants.stateOfficerList,
        query: {"status": field},
      );
      if (resp.statusCode == HttpStatus.ok) {
        return OfficerListResponseModel.fromJson(resp.data);
      } else {
        OfficerListResponseModel modelData = OfficerListResponseModel();
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
}
