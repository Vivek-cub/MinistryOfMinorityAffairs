import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_permission_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';
import 'package:path_provider/path_provider.dart';

/// Work Detail controller
/// Manages state and business logic for Work Detail screen
class WorkDetailController extends GetxController
    with SnackBarMixin, PopupMixin {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;
  final CaptureProjectVideo captureProjectVideo;

  // Remarks controller
  final remarksController = TextEditingController();

  // Loading state
  final isSubmitting = false.obs;

  WorkDetailController(
    this.repository,
    this.repo,
    this.authService,
    this.dbRepo,
    this.captureProjectVideo,
  );
  Rx<UnitDetails> data = UnitDetails().obs;
  RxString videoPath = "".obs;
  String? audioPath = "";
  String? finalVideoPath = "";
  RxList<ProjectMilestone> milestones = <ProjectMilestone>[].obs;
  RxString selectedMilestoneId = ''.obs;
  RxString projectStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
    // checkGeoFence();
  }

  void _initializeProjectData() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? UnitDetails();
      projectStatus.value = args['status'];
    }

    // if (data.value.milestones != null && data.value.milestones!.isNotEmpty) {
    //   milestones(data.value.milestones);
    //   if (selectedMilestoneId.value.isEmpty) {
    //     selectedMilestoneId.value =
    //         _defaultMilestoneId(data.value.milestones) ?? "";
    //   }
    // }
    saveToLocalDb();
  }

  void saveToLocalDb() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;
    await dbRepo.saveProject(data.value, userId);
  }

  Future<void> onCaptureVideo() async {
    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
    );

    if (!insideGeofence) {
      showErrorDialog(Get.context!, message: "You are outside the location");
      return;
    }

    var showedLoading = false;

    try {
      final compressedFile = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),
        onCompressionStarted: () {
          showedLoading = true;
          showAlertCustom(backBtnDisable: true, title: "Loading...");
        },
      );

      if (compressedFile == null) return;

      videoPath.value = compressedFile.path;
      finalVideoPath = compressedFile.path;
    } finally {
      if (showedLoading && (Get.isDialogOpen ?? false)) {
        Get.back();
      }
    }
  }

  Future<bool> checkGeoFence(double lat, double lng) async {
    final granted = await LocationPermissionService.request();
    if (!granted) return false;

    final Position position = await LocationService.getAccurateLocation();

    if (lat == 0.0 && lng == 0.0) return true;

    final isInside = GeoFenceService.isInside(
      user: position,
      targetLat: lat,
      targetLng: lng,
      radius: 200,
    );

    debugPrint(
      '${position.latitude} ${position.longitude}${position.altitude}',
    );

    if (isInside) {
      debugPrint("Inside geo fence loaction");
      return true;
    } else {
      debugPrint("Outside geo fence loaction");
      return false;
    }
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  void selectMilestone(String id) {
    selectedMilestoneId.value = id;
  }

  bool isSelected(String id) {
    return selectedMilestoneId.value == id;
  }

  bool get isCompletedProject =>
      projectStatus.value == "Completed" || data.value.status == "Completed";

  String? get existingApiVideoPath {
    final apiVideo = data.value.videoAtt;
    if (apiVideo == null || apiVideo.isEmpty) {
      return null;
    }
    if (apiVideo.startsWith('http://') || apiVideo.startsWith('https://')) {
      final normalized = _normalizeVideoUrl(apiVideo);
      debugPrint('Resolved API video URL: $normalized');
      return normalized;
    }

    final rawBaseUrl =
        NetworkConstants.baseUrl.replaceFirst('baseUrl=', '').trim();
    final baseUri = Uri.parse(rawBaseUrl);
    final cleanedPath = apiVideo.replaceAll('\\', '/').trim();
    final resolved = baseUri.resolve(cleanedPath);
    final normalized = _normalizeVideoUrl(resolved.toString());
    debugPrint('Resolved API video URL: $normalized');
    return normalized;
  }

  String _normalizeVideoUrl(String value) {
    final cleaned = value.replaceAll('\\', '/').trim();
    final parsed = Uri.parse(cleaned);

    final encodedPathSegments =
        parsed.pathSegments.map(Uri.encodeComponent).toList();

    return parsed.replace(pathSegments: encodedPathSegments).toString();
  }

  String? get displayedVideoPath {
    if (videoPath.value.isNotEmpty) {
      return videoPath.value;
    }
    return existingApiVideoPath;
  }

  bool get isShowingApiVideoOnly =>
      videoPath.value.isEmpty && (existingApiVideoPath?.isNotEmpty ?? false);

  bool get canSubmitCompletedVideo => finalVideoPath?.isNotEmpty == true;

  String get effectiveMilestoneId {
    if (selectedMilestoneId.value.isNotEmpty) {
      return selectedMilestoneId.value;
    }
    return "";
    // return _defaultMilestoneId(data.value.milestones) ?? "";
  }

  String? _defaultMilestoneId(List<ProjectMilestone>? milestoneList) {
    if (milestoneList == null || milestoneList.isEmpty) return null;

    final pendingIndex = milestoneList.indexWhere(
      (milestone) => milestone.status != "Completed",
    );

    if (pendingIndex != -1) {
      return milestoneList[pendingIndex].id;
    }

    return milestoneList.last.id;
  }

  void clearVideoSelection() {
    videoPath.value = "";
    finalVideoPath = "";
  }

  Future<void> saveCompletedVideoOffline() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: "Unable to identify current user");
      return;
    }

    final milestoneId = effectiveMilestoneId;
    if (milestoneId.isEmpty) {
      showErrorDialog(Get.context!, message: "No milestone found for project");
      return;
    }

    await repository.save(
      userId: userId,
      projectId: data.value.id ?? '',
      images: const [],
      audioPath: null,
      videoPath: finalVideoPath,
      remarks: remarksController.text,
      isSynced: false,
      userLat: "",
      userLng: "",
      progress: "100",
      projectStatus: "Completed",
    );

    Get.snackbar(
      'Saved Offline',
      'No internet. Video will sync automatically',
      snackPosition: SnackPosition.BOTTOM,
    );

    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.checkInternet();
    }

    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> submitCompletedVideoOnline() async {
    try {
      // final milestoneId = effectiveMilestoneId;
      // if (milestoneId.isEmpty) {
      //   showErrorDialog(
      //     Get.context!,
      //     message: "No milestone found for project",
      //   );
      //   return;
      // }

      showAlertCustom(backBtnDisable: true, title: "Uploading...");

      final modelData = await repo.uploadMilestoneFiles(
        projectId: data.value.id ?? '',

        imagePaths: const [],
        videoPath: finalVideoPath,
        audioPath: null,
        userLat: "",
        userLng: "",
        progress: "100",
        projectStatus: "Completed",
        remarks: remarksController.text,
      );

      Get.back();

      if (modelData.statusCode == '200') {
        await _cleanupUploadedCompletionVideo();
        showSuccessDialog(
          Get.context!,
          message: "Video uploaded successfully",
          onPressed: () {
            Get.offAllNamed(AppRoutes.home);
          },
        );
      } else {
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.error ?? "Something went wrong.",
          onPressed: () {
            Get.back();
          },
        );
      }
    } catch (e) {
      Get.back();
      showErrorDialog(Get.context!, message: "Video upload failed");
    }
  }

  Future<void> submitCompletedVideo() async {
    if (finalVideoPath == null || finalVideoPath!.isEmpty) {
      showErrorDialog(Get.context!, message: "Please upload video");
      return;
    }

    final hasInternet = await NetworkService.hasInternet();

    if (hasInternet) {
      await submitCompletedVideoOnline();
    } else {
      showMessageDialog(
        Get.context!,
        title: "NO Internet!",
        message: "Want to save this in Local Database?",
        onPressed: () async {
          await saveCompletedVideoOffline();
        },
      );
    }
  }

  //   Future<File> compressVideoIfNeeded(File file) async {
  //     const int maxSize = 25 * 1024 * 1024; // 25 MB

  //     final originalSize = await file.length();
  //     debugPrint("video size before  $originalSize");
  //     // Already below 25 MB
  //     if (originalSize <= maxSize) {
  //       return file;
  //     }

  //     final tempDir = await offlineMediaDir();

  //     final outputPath = p.join(
  //       tempDir.path,
  //       'compressed_video_${DateTime.now().millisecondsSinceEpoch}.mp4',
  //     );

  //     final command = '''
  // -y -i "${file.path}"
  // -vf scale='min(1280,iw)':-2
  // -c:v libx264
  // -preset veryfast
  // -b:v 1000k
  // -maxrate 1200k
  // -bufsize 2000k
  // -c:a aac
  // -b:a 96k
  // -movflags +faststart
  // "$outputPath"
  // ''';

  //     await FFmpegKit.execute(command);

  //     final compressedFile = File(outputPath);

  //     if (!compressedFile.existsSync()) {
  //       return file;
  //     }
  //     final newSize = await compressedFile.length();
  //     debugPrint("video size before  $originalSize");
  //     return compressedFile;
  //   }

  Future<Directory> offlineMediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/offline_media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  Future<void> _cleanupUploadedCompletionVideo() async {
    final path = finalVideoPath;
    if (path == null || path.isEmpty) return;

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Failed to delete uploaded completion video: $e');
    }

    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;

    try {
      await dbRepo.deleteUploadedLocalAttachmentPaths(
        userId: userId,
        projectId: data.value.id ?? '',
        filePaths: [path],
      );
    } catch (e) {
      debugPrint('Failed to delete uploaded cached video path: $e');
    }
  }
}
