import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';

import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/domain/functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class FunctionalRepoImpl extends FunctionalRepo with PopupMixin, SnackBarMixin {
  final ApiService apiService;
  FunctionalRepoImpl(this.apiService);

  @override
  Future<FunctionalResponseModel> getQuestionaire({
    required String unitId,
    required String sectorId,
  }) async {
    try {
      final url = "${NetworkConstants.getQuestionnaire}$unitId/questions";
      final resp = await apiService.get(
        url,
        // data: {"sectorId": sectorId}
      );

      if (resp.statusCode == HttpStatus.ok && resp.data != null) {
        return FunctionalResponseModel.fromJson(resp.data);
      } else {
        FunctionalResponseModel model = FunctionalResponseModel();
        showErrorDialog(
          Get.context!,
          title: model.error ?? "Error",
          message: "Something Went Wrong",
        );
        return model;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  @override
  Future<CommonResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
    required List<Map<String, dynamic>> media,
  }) async {
    try {
      final url = "${NetworkConstants.postQuestionnaire}$unitId/submit";

      final formData = FormData();

      // ============================================================
      // 1. PROJECT ID
      // ============================================================

      formData.fields.add(
        MapEntry('projectId', formValues['projectId']?.toString() ?? ''),
      );

      // ============================================================
      // 2. ASSESSMENT
      // ============================================================

      final assessment = formValues['assessment'] ?? [];

      formData.fields.add(MapEntry('assessment', jsonEncode(assessment)));

      // ============================================================
      // 3. IMAGE / VIDEO FILES
      // ============================================================

      for (final item in media) {
        final questionId = item['questionId']?.toString();
        final questionType = item['questionType']?.toString().toUpperCase();
        final path = item['path']?.toString();

        if (questionId == null ||
            questionId.isEmpty ||
            path == null ||
            path.isEmpty) {
          continue;
        }

        final file = File(path);

        if (!await file.exists()) {
          debugPrint('Media file does not exist: $path');
          continue;
        }

        final filename = path.split('/').last;

        // ------------------------------------------------------------
        // IMAGE
        // ------------------------------------------------------------

        if (questionType == 'IMAGE' || questionType == 'IMAGES') {
          formData.files.add(
            MapEntry(
              'image_$questionId',
              await MultipartFile.fromFile(path, filename: filename),
            ),
          );

          debugPrint('Image added: image_$questionId -> $path');
        }
        // ------------------------------------------------------------
        // VIDEO
        // ------------------------------------------------------------
        else if (questionType == 'VIDEO') {
          formData.files.add(
            MapEntry(
              'video_$questionId',
              await MultipartFile.fromFile(path, filename: filename),
            ),
          );

          debugPrint('Video added: video_$questionId -> $path');
        }
      }

      // ============================================================
      // DEBUG
      // ============================================================

      debugPrint('========== SUBMIT QUESTIONNAIRE ==========');

      debugPrint('URL: $url');

      debugPrint('Project ID: ${formValues['projectId']}');

      debugPrint('Assessment: ${jsonEncode(assessment)}');

      debugPrint('Media count: ${media.length}');

      for (final item in media) {
        debugPrint(
          'Media => '
          'questionId: ${item['questionId']}, '
          'questionType: ${item['questionType']}, '
          'path: ${item['path']}',
        );
      }

      debugPrint('==========================================');

      // ============================================================
      // 4. API CALL
      // ============================================================

      final response = await apiService.post(
        url,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      debugPrint('Status: ${response.statusCode}');

      debugPrint('Response: ${response.data}');

      // ============================================================
      // 5. ONLY 200 = SUCCESS
      // ============================================================

      if (response.statusCode == HttpStatus.ok) {
        return CommonResponseModel.fromJson(response.data);
      }

      return CommonResponseModel(
        statusCode: response.statusCode?.toString(),
        error:
            response.data?['message']?.toString() ??
            response.data?['error']?.toString() ??
            'Unable to submit questionnaire.',
      );
    } on DioException catch (e) {
      debugPrint('========== SUBMIT QUESTIONNAIRE ERROR ==========');

      debugPrint('Status: ${e.response?.statusCode}');

      debugPrint('Response: ${e.response?.data}');

      debugPrint('Request: ${e.requestOptions.data}');

      debugPrint('===============================================');

      return CommonResponseModel(
        statusCode: e.response?.statusCode?.toString(),
        error:
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            e.message ??
            'Unable to submit questionnaire.',
      );
    } catch (e) {
      debugPrint('submitQuestionnaire error: $e');

      return CommonResponseModel(statusCode: '500', error: e.toString());
    }
  }

  @override
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    String? videoPath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'projectId': projectId,
        'isFunctional': isFunctional.toString(),
      });

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

      debugPrint('========== UPDATE FUNCTIONALITY ==========');
      debugPrint('projectId: $projectId');
      debugPrint('isFunctional: $isFunctional');
      debugPrint('videoPath: $videoPath');
      debugPrint('===========================================');

      final response = await apiService.post(
        NetworkConstants.updateFunctionality,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      }

      return CommonResponseModel(
        statusCode: response.statusCode?.toString(),
        error:
            response.data?['message']?.toString() ??
            response.data?['error']?.toString(),
      );
    } on DioException catch (e) {
      debugPrint('========== UPDATE FUNCTIONALITY ERROR ==========');
      debugPrint('Status: ${e.response?.statusCode}');
      debugPrint('Response: ${e.response?.data}');
      debugPrint('Request: ${e.requestOptions.data}');
      debugPrint('=================================================');

      rethrow;
    } catch (e) {
      debugPrint('updateFunctionality error: $e');
      rethrow;
    }
  }
}
