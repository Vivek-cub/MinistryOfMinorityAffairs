import 'dart:io';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/domain/repo/update_proposal_latlng_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class UpdateProposalLatlngImpl extends UpdateProposalLatlngRepo
    with PopupMixin, SnackBarMixin {
  final ApiService apiService;
  UpdateProposalLatlngImpl(this.apiService);

  @override
  Future<CommonResponseModel?> updateProposalLatlng({
    required String projectId,
    required String lat,
    required String lng,
  }) async {
    try {
      final resp = await apiService.post(
        NetworkConstants.updateLatLng,
        data: {"projectId": projectId, "lat": lat, "lng": lng},
      );
      if (resp.statusCode == HttpStatus.ok) {
        return CommonResponseModel.fromJson(resp.data);
      } else {
        CommonResponseModel modelData = CommonResponseModel();
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
