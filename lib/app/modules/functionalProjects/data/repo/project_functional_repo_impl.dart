import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/model/questionaire_data_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/repo/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/model/home_resp_model.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class ProjectFunctionalRepoImpl extends ProjectFunctionalRepo
    with PopupMixin, SnackBarMixin {
  final ApiService apiService;
  ProjectFunctionalRepoImpl(this.apiService);
  @override
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    // Map<String, dynamic> formValues = const {},
    String? videoPath,
  }) async {
    try {
      //final formData = FormData();
      final formData = FormData.fromMap({
        'projectId': projectId,
        'isFunctional': isFunctional,
      });
      // formData.fields.addAll([
      //   MapEntry('projectId', projectId),
      //   MapEntry('isFunctional', isFunctional),
      // ]);

      // Optional video
      if (videoPath != null && videoPath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'video',
            await MultipartFile.fromFile(
              videoPath,
              filename: videoPath.split('/').last,
            ),
          ),
        );
      }

      final response = await apiService.post(
        NetworkConstants.updateFunctionality,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        return CommonResponseModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getQuestionaire({
    required String unitId,
  }) async {
    try {
      final url = "${NetworkConstants.getQuestionnaire}/$unitId";
      final resp = await apiService.get(url);

      if (resp.statusCode == HttpStatus.ok && resp.data != null) {
        return resp.data;
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
      return null;
    }
  }

  @override
  Future<CommonResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
  }) async {
    try {
      final url = "${NetworkConstants.getQuestionnaire}/$unitId";

      final response = await apiService.post(
        url,
        data: formValues,
        options: Options(contentType: Headers.jsonContentType),
      );

      debugPrint('========== QUESTIONNAIRE POST ==========');

      debugPrint('URL: $url');
      debugPrint('BODY: $formValues');
      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.data}');

      debugPrint('========================================');

      if (response.statusCode == HttpStatus.ok) {
        return CommonResponseModel.fromJson(response.data);
      }

      return CommonResponseModel();
    } catch (e) {
      debugPrint('submitQuestionnaire error: $e');

      rethrow;
    }
  }
}
