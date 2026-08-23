import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_response.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/data/model/state_dashboard_response_model.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/repo/state_dashboard_repo.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class StateDashboardRepoImpl extends StateDashboardRepo
    with PopupMixin, SnackBarMixin {
  final ApiService apiService;

  StateDashboardRepoImpl(this.apiService);

  @override
  Future<ProjectResponse?> getNonWorkingOfficerList() {
    // TODO: implement getNonWorkingOfficerList
    throw UnimplementedError();
  }

  @override
  Future<StateDashboardResponseModel?> getStateDashboardData() async {
    try {
      final resp = await apiService.get(NetworkConstants.stateDashboard);
      if (resp.statusCode == HttpStatus.ok) {
        return StateDashboardResponseModel.fromJson(resp.data);
      } else {
        StateDashboardResponseModel modelData = StateDashboardResponseModel();
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.statusMessage ?? "Something Went Wrong",
        );
        return modelData;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<CommonResponseModel?> uploadProfileImage({required String image}) {
    // TODO: implement uploadProfileImage
    throw UnimplementedError();
  }

  @override
  Future<List<int>?> exportAssignedProjects({required String userId}) async {
    try {
      final resp = await apiService.get(
        NetworkConstants.exportAssignedProjects,
        query: {"userId": userId},
        options: Options(responseType: ResponseType.bytes),
      );
      if (resp.statusCode == HttpStatus.ok) {
        return List<int>.from(resp.data as List);
      } else {
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: "Something Went Wrong",
        );
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }
}
