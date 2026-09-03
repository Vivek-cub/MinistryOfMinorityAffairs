import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/repo/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';

class SyncService extends GetxService {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final ProjectFunctionalRepo functionalRepo;

  SyncService(this.repository, this.repo, this.functionalRepo);

  Future<void> _syncPendingSubmissions() async {
    final hasInternet = await NetworkService.hasInternet();
    if (!hasInternet) return;
    final userId = await Get.find<AuthService>().getUserToken();
    if (userId == null || userId.isEmpty) return;

    final pendingList = await repository.getPending(userId: userId);

    for (final item in pendingList) {
      try {
        if (item.submission.progress ==
            OfflineSubmissionType.functionalProject) {
          final questionnaireSynced = await _syncFunctionalQuestionnaire(item);
          if (!questionnaireSynced) continue;

          final response = await functionalRepo.updateFunctionality(
            projectId: item.submission.projectId,
            isFunctional: item.submission.projectStatus == 'true',
            videoPath: item.video?.filePath,
          );

          if (response.statusCode == '200') {
            await _cleanupUploadedSubmission(item, userId);
          }
          continue;
        }

        await _logUploadMediaSizes(
          imagePaths: item.images.map((e) => e.filePath).toList(),
          audioPath: item.audio?.filePath,
          videoPath: item.video?.filePath,
          source: 'service offline sync',
        );
        final response = await repo.uploadMilestoneFiles(
          projectId: item.submission.projectId,
          imagePaths: item.images.map((e) => e.filePath).toList(),
          audioPath: item.audio?.filePath,
          videoPath: item.video?.filePath,
          userLat: item.submission.userLat,
          userLng: item.submission.userLng,
          progress: item.submission.progress,
          projectStatus: item.submission.projectStatus,
          remarks: item.remark?.remarks ?? "",
        );

        if (response.statusCode == '200') {
          await _cleanupUploadedSubmission(item, userId);
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  Future<bool> _syncFunctionalQuestionnaire(PendingSubmission item) async {
    if (item.submission.projectStatus != 'true') return true;

    final formValues = _decodeQuestionnairePayload(
      item.submission.questionnairePayload,
    );
    if (formValues.isEmpty) return true;

    final response = await functionalRepo.submitQuestionnaire(
      unitId: item.submission.projectId,
      formValues: formValues,
    );

    return response.statusCode == '200';
  }

  Map<String, dynamic> _decodeQuestionnairePayload(String? payload) {
    if (payload == null || payload.trim().isEmpty) return <String, dynamic>{};

    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (e) {
      debugPrint('Failed to decode offline questionnaire payload: $e');
    }

    return <String, dynamic>{};
  }

  Future<void> _cleanupUploadedSubmission(
    PendingSubmission item,
    String userId,
  ) async {
    final uploadedPaths = <String>[
      ...item.images.map((e) => e.filePath),
      if (item.audio?.filePath.isNotEmpty == true) item.audio!.filePath,
      if (item.video?.filePath.isNotEmpty == true) item.video!.filePath,
    ];

    for (final path in uploadedPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Failed to delete uploaded media file: $e');
      }
    }

    await repository.deleteUploadedSubmission(item.submission.id, userId);

    final cachedProjectRepo = ProjectRepository(
      ProjectDao(Get.find<AppDatabase>()),
    );
    try {
      await cachedProjectRepo.deleteUploadedLocalAttachmentPaths(
        userId: userId,
        projectId: item.submission.projectId,
        filePaths: uploadedPaths,
      );
    } catch (e) {
      debugPrint('Failed to delete uploaded cached attachment paths: $e');
    }
  }

  Future<void> _logUploadMediaSizes({
    required List<String> imagePaths,
    String? audioPath,
    String? videoPath,
    required String source,
  }) async {
    final paths = <String>[
      ...imagePaths,
      if (audioPath?.isNotEmpty == true) audioPath!,
      if (videoPath?.isNotEmpty == true) videoPath!,
    ];

    int totalBytes = 0;
    debugPrint('Upload size check: $source');

    for (final path in paths) {
      final file = File(path);
      if (!await file.exists()) {
        debugPrint('Missing upload file: $path');
        continue;
      }

      final bytes = await file.length();
      totalBytes += bytes;
      debugPrint(
        'Upload file: ${path.split('/').last} | '
        '${(bytes / 1024).toStringAsFixed(2)} KB | $path',
      );
    }

    debugPrint(
      'Upload total media size: ${(totalBytes / 1024).toStringAsFixed(2)} KB',
    );
  }
}
