import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ministry_of_minority_affairs/app/core/model/common_response_model.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/submit_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/domain/functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_capture_service.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_compressor.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';

FunctionalController buildFunctionalController({
  FunctionalRepo? repo,
  CaptureProjectVideo? captureProjectVideo,
  SubmissionRepository? repository,
  AuthService? authService,
}) {
  return FunctionalController(
    captureProjectVideo ?? FakeCaptureProjectVideo(),
    repo ?? FakeFunctionalRepo(),
    repository ?? FakeSubmissionRepository(),
    authService ?? TestAuthService(),
  );
}

class FakeFunctionalRepo implements FunctionalRepo {
  @override
  Future<FunctionalResponseModel> getQuestionaire({
    required String unitId,
    required String sectorId,
  }) async {
    return FunctionalResponseModel(data: const []);
  }

  @override
  Future<SubmitResponseModel> submitQuestionnaire({
    required String unitId,
    required Map<String, dynamic> formValues,
    required List<Map<String, dynamic>> media,
  }) async {
    return SubmitResponseModel(success: true);
  }

  @override
  Future<CommonResponseModel> updateFunctionality({
    required String projectId,
    required bool isFunctional,
    String? videoPath,
  }) async {
    return CommonResponseModel(statusCode: '200');
  }
}

class FakeCaptureProjectVideo implements CaptureProjectVideo {
  @override
  final VideoCaptureService captureService = UnusedVideoCaptureService();

  @override
  final VideoCompressor compressor = UnusedVideoCompressor();

  @override
  Future<File?> call({
    Duration maxDuration = const Duration(minutes: 2),
    void Function()? onCompressionStarted,
  }) async {
    return null;
  }
}

class UnusedVideoCaptureService implements VideoCaptureService {
  @override
  Future<File?> captureFromCamera({
    Duration maxDuration = const Duration(minutes: 2),
  }) async {
    return null;
  }
}

class UnusedVideoCompressor implements VideoCompressor {
  @override
  Future<File> compressIfNeeded(
    File file, {
    void Function()? onCompressionStarted,
  }) async {
    return file;
  }
}

class FakeSubmissionRepository extends Fake implements SubmissionRepository {}

class TestAuthService extends AuthService {
  TestAuthService() : super(InMemoryStorageService());
}

class InMemoryStorageService extends SStorageService {
  final Map<SStorageKeys, String> _values = {};

  @override
  Future<String?> readKey({required SStorageKeys key}) async => _values[key];

  @override
  Future<void> writeKey({
    required SStorageKeys key,
    required String value,
  }) async {
    _values[key] = value;
  }

  @override
  Future<void> deleteKey(SStorageKeys key) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }

  @override
  Future<Map<String, String>> get allValues async {
    return {
      for (final entry in _values.entries) entry.key.toString(): entry.value,
    };
  }
}
