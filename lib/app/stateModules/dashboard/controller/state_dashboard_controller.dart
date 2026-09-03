import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/local/offline_submission_type.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/domain/repo/project_functional_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/capture_image_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_notification_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/field_officer_not_visited.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/state_dashboard_data.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/repo/state_dashboard_repo.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import 'package:public_file_saver/public_file_saver.dart';

class StateDashboardController extends GetxController
    with SnackBarMixin, CompressMixin, CaptureImageMixin {
  final StateDashboardRepo repo;
  final AuthService authService;
  final SubmissionRepository submissionRepo;
  final ProjectDetailRepo projectRepo;
  final ProjectFunctionalRepo functionalRepo;

  StateDashboardController(
    this.repo,
    this.authService,
    this.submissionRepo,
    this.projectRepo,
    this.functionalRepo,
  );
  final userName = ''.obs;
  final assignedState = ''.obs;
  Rx<StateDashboardData> data = StateDashboardData().obs;
  RxBool hasInternet = true.obs;
  final RxList<FieldOfficersNotVisited> fieldOfficerNotVisited =
      <FieldOfficersNotVisited>[].obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxString profileImage = "".obs;
  final isSyncing = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final isLoading = true.obs;
  RxString userRole = "".obs;
  final FirebaseNotificationService notificationService =
      Get.find<FirebaseNotificationService>();
  final isExportingAssignedProjects = false.obs;

  @override
  void onInit() {
    super.onInit();
    _listenForInternetRestore();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternet();
    });
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  void _listenForInternetRestore() {
    //isSyncing.value = true;
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final hasNetwork = results.any(
        (result) => result != ConnectivityResult.none,
      );
      if (!hasNetwork) {
        hasInternet.value = false;
        return;
      }
      final wasOffline = hasInternet.value == false;
      final online = await NetworkService.hasInternet();
      hasInternet.value = online;
      if (wasOffline && online) {
        await checkInternet();
      }
    });
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  Future<void> checkInternet() async {
    if (isSyncing.value) return;
    isSyncing.value = true;
    isLoading.value = true;
    hasInternet.value = await NetworkService.hasInternet();
    if (!hasInternet.value) {
      isSyncing.value = false;
      return;
    }
    try {
      await getDashboardCount();
      await syncPendingSubmissions();
      userRole.value = await authService.getUserRole() ?? "";
    } finally {
      isSyncing.value = false;
      isLoading.value = false;
    }
  }

  void onUpdateProgressTap(
    UnitDetails project,
    String status,
    String id,
    UserProject userProject,
    bool fromUrgentList,
  ) {
    Get.toNamed(
      AppRoutes.uploadProjectDetails,
      arguments: {
        "project": project,
        "status": status,
        "id": id,
        "userProject": fromUrgentList == true ? userProject : null,
      },
    );
  }

  void onViewAllTap() {
    // Navigate to work in progress screen
    Get.toNamed(
      AppRoutes.projectList,
      arguments: {
        'status': "pending",
        'paramName': "pending",
        'statusFilter': "all",
      },
    );
  }

  Future<void> getDashboardCount() async {
    try {
      final modelData = await repo.getStateDashboardData();

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null) {
          data.value = modelData!.data!;
          userName(data.value.user?.name ?? "");
          assignedState(data.value.user?.state ?? "");
          fieldOfficerNotVisited(data.value.fieldOfficersNotVisited);

          await authService.setUserId(modelData.data?.user?.id ?? '');
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> syncPendingSubmissions() async {
    final hasInternet = await NetworkService.hasInternet();
    if (!hasInternet) return;
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;

    final pendingList = await submissionRepo.getPending(userId: userId);
    if (pendingList.isEmpty) return;

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
          source: 'home offline sync',
        );
        final response = await projectRepo.uploadMilestoneFiles(
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

    await submissionRepo.deleteUploadedSubmission(item.submission.id, userId);

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

  Future<void> uploadProfileImage(String profilePic) async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Setting Profile Image...");
      final model = await repo.uploadProfileImage(image: profilePic);
      if (model?.statusCode == "200") {
        Get.back();
        getDashboardCount();
      } else {
        Get.back();
        Get.snackbar("Error", "Failed to upload profile image");
      }
    } catch (e) {
      Get.back();
    } finally {}
  }

  Future<void> takePhoto() async {
    try {
      final File? image = await captureImage();
      profileImage(image?.path);
      uploadProfileImage(profileImage.value);
    } catch (e) {
      Helpers.showError("Failed to capture photo");
    }
  }

  Future<void> exportAssignedProjectsExcel() async {
    if (isExportingAssignedProjects.value) return;

    final online = await NetworkService.hasInternet();

    if (!online) {
      Get.snackbar("No Internet", "Please connect to internet and try again");
      return;
    }

    final userId = await authService.getUserId();

    if (userId == null || userId.isEmpty) {
      Get.snackbar("Error", "User id is missing");
      return;
    }

    const notificationId = 98765;

    final fileName = _exportFileName();

    try {
      isExportingAssignedProjects.value = true;

      // Show initial notification
      await notificationService.showDownloadProgress(
        notificationId: notificationId,
        fileName: fileName,
        progress: 0,
      );

      final bytes = await repo.exportAssignedProjects(userId: userId);

      if (bytes == null || bytes.isEmpty) {
        await notificationService.showDownloadFailed(
          notificationId: notificationId,
          fileName: fileName,
        );

        Get.snackbar("Error", "Unable to download assigned projects");

        return;
      }

      final savedFile = await PublicFileSaver().saveBytes(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        subDir: 'MoMA',
      );

      final fileReference = savedFile?.uri ?? savedFile?.path;

      if (savedFile?.isSuccess != true || fileReference == null) {
        await notificationService.showDownloadFailed(
          notificationId: notificationId,
          fileName: fileName,
        );

        Get.snackbar("Error", "Unable to save assigned projects");

        return;
      }

      // Complete notification
      await notificationService.showDownloadComplete(
        notificationId: notificationId,
        fileName: fileName,
        filePath: fileReference,
      );

      Get.snackbar(
        "Download Complete",
        "Assigned projects exported to Downloads/MoMA",
      );
    } catch (e, stackTrace) {
      debugPrint("Failed to export assigned projects: $e");

      debugPrintStack(stackTrace: stackTrace);

      await notificationService.showDownloadFailed(
        notificationId: notificationId,
        fileName: fileName,
      );

      Get.snackbar("Error", "Failed to download assigned projects");
    } finally {
      isExportingAssignedProjects.value = false;
    }
  }

  String _exportFileName() {
    final timestamp = DateTime.now().toIso8601String().replaceAll(
      RegExp(r'[:.]'),
      '-',
    );

    return 'assigned_projects_$timestamp.xlsx';
  }
}
