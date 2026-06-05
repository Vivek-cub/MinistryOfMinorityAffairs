import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/entity/home_data.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/domain/repo/project_list_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Home screen controller
/// Manages home screen state and business logic
class HomeController extends GetxController with SnackBarMixin {
  final HomeRepo repo;
  final ProjectListRepo projectListRepo;
  final AuthService authService;
  final SubmissionRepository submissionRepo;
  final ProjectDetailRepo projectRepo;

  HomeController(
    this.repo,
    this.authService,
    this.submissionRepo,
    this.projectRepo,
    this.projectListRepo,
  );
  // User info
  final userName = ''.obs;

  // Dashboard statistics
  final dashboardStats = Rx<DashboardStats>(
    DashboardStats(
      totalAssigned: 1367,
      inProgress: 507,
      notStarted: 623,
      completed: 237,
      geotagged: 600,
      nonGeotagged: 767,
    ),
  );

  // Work list

  Rx<HomeData> data = HomeData().obs;
  RxBool hasInternet = true.obs;
  final RxList<UserProject> projects = <UserProject>[].obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxString profileImage = "".obs;
  final isSyncing = false.obs;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

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
    hasInternet.value = await NetworkService.hasInternet();
    if (!hasInternet.value) return;
    try {
      isSyncing.value = true;
      await getDashboardCount();
      await loadProjects();
      if ((data.value.projectsNotVisitedFor3Months ?? 0) > 0) {
        await loadUrgentProjects();
      }
      await syncPendingSubmissions();
    } finally {
      isSyncing.value = false;
    }
  }

  void onUpdateProgressTap(ProjectDetails project, String status) {
    // Navigate to project detail/update page
    // Get.toNamed(
    //   AppRoutes.workDetail,
    //   arguments: {"project": project, "status": status},
    // );

    Get.toNamed(
      AppRoutes.uploadProjectDetails,
      arguments: {"project": project, "status": status},
    );
  }

  void onViewAllTap() {
    // Navigate to work in progress screen
    Get.toNamed(
      AppRoutes.projectList,
      arguments: {
        'status': "All",
        'paramName': "status",
        'statusFilter': "all",
      },
    );
  }

  void onChangePinTap() {
    Get.toNamed(AppRoutes.oldPinCheck);
  }

  void onDashboardTap() {
    Get.toNamed(AppRoutes.home);
  }

  void onCalendarTap() {
    Get.toNamed(
      AppRoutes.projectList,
      arguments: {
        'status': "All",
        'paramName': "status",
        'statusFilter': "All",
        'showCalendar': true,
      },
    );
    // Get.toNamed(AppRoutes.calendarProject);
  }

  void onProjetTap() {
    Get.toNamed(
      AppRoutes.projectList,
      arguments: {
        'status': "Completed",
        'paramName': "status",
        'statusFilter': "completed",
      },
    );
  }

  void onLogoutTap() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () async {
        Get.back();
        // Perform logout
        await authService.onLogout();
        Get.snackbar(
          'Logged Out',
          'You have been logged out successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offNamed(AppRoutes.splash);
      },
    );
  }

  Future<void> getDashboardCount() async {
    try {
      final modelData = await repo.getHomeData();

      if (modelData?.statusCode == "200") {
        if (modelData?.data != null) {
          data.value = modelData!.data!;
          userName(data.value.user?.name ?? "");
          await authService.setUserId(modelData.data?.user?.id ?? '');
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {}
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
      } catch (_) {}
    }
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

  // List<PendingSubmission> _uniqueByProjectId(List<PendingSubmission> list) {
  //   final seen = <String>{};
  //   final result = <PendingSubmission>[];

  //   for (final item in list) {
  //     final projectId = item.submission.projectId;
  //     if (seen.add(projectId)) {
  //       result.add(item); // first occurrence kept
  //     }
  //   }

  //   return result;
  // }

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
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image == null) return;

      // 🔑 Convert XFile → File
      final File originalFile = File(image.path);

      final File finalFile = await compressIfNeeded(originalFile);

      profileImage.value = finalFile.path;

      final sizeKb = (await finalFile.length()) / 1024;
      debugPrint('Final image size: ${sizeKb.toStringAsFixed(2)} KB');
      uploadProfileImage(profileImage.value);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<File> compressIfNeeded(File file) async {
    final bytes = await file.length();

    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await getTemporaryDirectory();
    final targetPath = p.join(
      tempDir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    int quality = 85;
    File? compressed;

    while (quality >= 30) {
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (result == null) break;

      final File resultFile = File(result.path);

      final size = await resultFile.length();
      if (size <= 1024 * 1024) {
        compressed = resultFile;
        break;
      }

      quality -= 10;
    }

    return compressed ?? file;
  }

  Future<void> loadProjects() async {
    try {
      final modelData = await projectListRepo.getProjectList(
        status: "All",
        paramName: "status",
        sectorId: "",
        year: "",
        startDate: "",
        endDate: "",
      );
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          projects.value = modelData!.data?.projects ?? [];
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch dashboard data");
    } finally {}
  }

  Future<void> loadUrgentProjects() async {
    try {
      final modelData = await projectListRepo.getProjectList(
        status: "All",
        paramName: "status",
        sectorId: "",
        year: "",
        startDate: "",
        endDate: "",
      );
      if (modelData?.statusCode == "200") {
        if (modelData?.data != null && modelData?.data?.projects != null) {
          projects.value = modelData!.data?.projects ?? [];
        }
      } else {
        Get.snackbar("Error", "Failed to fetch dashboard data");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch dashboard data");
    } finally {}
  }
}
