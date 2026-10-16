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
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/submit_response_model.dart';
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

  // Replace submitQuestionnaire in your repository implementation.
  // Sends JSON when there are no files (matches the required body),
  // and multipart only when media exists.

  @override
  Future<SubmitResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
    required List<Map<String, dynamic>> media,
  }) async {
    try {
      final url = "${NetworkConstants.postQuestionnaire}$unitId/submit";

      final assessmentDate = formValues['assessmentDate']?.toString() ?? '';

      final answers = List<Map<String, dynamic>>.from(
        (formValues['answers'] as List? ?? []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );

      final mediaByQuestionId = <String, String>{
        for (final item in media)
          if (item['questionId'] != null && item['path'] != null)
            item['questionId'].toString(): item['path'].toString(),
      };

      final hasNewFiles = answers.any(
        (answer) => answer['answer'] == '__FILE__',
      );

      final hasImageUrls = answers.any((answer) {
        final value = answer['answer'];
        return value is String &&
            (value.startsWith('http://') || value.startsWith('https://'));
      });

      final useMultipart = hasNewFiles || hasImageUrls;

      dynamic data;
      Options options;

      if (!useMultipart) {
        data = {'assessmentDate': assessmentDate, 'answers': answers};

        options = Options(contentType: Headers.jsonContentType);
      } else {
        final formData = FormData();

        formData.fields.add(MapEntry('assessmentDate', assessmentDate));

        formData.fields.add(MapEntry('answers', jsonEncode(answers)));

        for (final answer in answers) {
          if (answer['answer'] != '__FILE__') continue;

          final questionId = answer['questionId']?.toString();
          final path = mediaByQuestionId[questionId];

          if (path == null || path.isEmpty) {
            throw Exception('No media found for questionId: $questionId');
          }

          // Existing URL: preserve it; do not upload it as a file.
          if (path.startsWith('http://') || path.startsWith('https://')) {
            answer['answer'] = path;
            continue;
          }

          // Local file: upload it.
          final file = File(path);

          if (!await file.exists()) {
            throw Exception('Media file does not exist: $path');
          }

          formData.files.add(
            MapEntry(
              'answer',
              await MultipartFile.fromFile(
                path,
                filename: path.split('/').last,
              ),
            ),
          );
        }

        // Re-encode answers because existing URLs may have replaced
        // __FILE__ placeholders above.
        formData.fields.removeWhere((field) => field.key == 'answers');

        formData.fields.add(MapEntry('answers', jsonEncode(answers)));

        data = formData;
        options = Options(contentType: Headers.multipartFormDataContentType);
      }

      debugPrint('SUBMIT QUESTIONNAIRE URL: $url');
      debugPrint('Assessment date: $assessmentDate');
      debugPrint('Answers: ${jsonEncode(answers)}');
      debugPrint('Media count: ${media.length}');
      debugPrint('Has new files: $hasNewFiles');
      debugPrint('Using multipart: $useMultipart');

      final response = await apiService.post(url, data: data, options: options);

      debugPrint('Status: ${response.statusCode}');
      debugPrint('Response: ${response.data}');

      if (response.statusCode == HttpStatus.ok) {
        return SubmitResponseModel.fromJson(response.data);
      }

      return SubmitResponseModel(
        success: false,
        error:
            response.data?['message']?.toString() ??
            response.data?['error']?.toString() ??
            'Unable to submit questionnaire.',
      );
    } on DioException catch (e) {
      debugPrint('SUBMIT QUESTIONNAIRE ERROR: ${e.response?.data}');

      return SubmitResponseModel(
        success: false,
        error:
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            e.message ??
            'Unable to submit questionnaire.',
      );
    } catch (e) {
      debugPrint('submitQuestionnaire error: $e');

      return SubmitResponseModel(success: false, error: e.toString());
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
