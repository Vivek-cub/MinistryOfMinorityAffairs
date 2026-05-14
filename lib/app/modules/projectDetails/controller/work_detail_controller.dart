import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
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

  // Remarks controller
  final remarksController = TextEditingController();

  // Loading state
  final isSubmitting = false.obs;

  WorkDetailController(
    this.repository,
    this.repo,
    this.authService,
    this.dbRepo,
  );
  Rx<ProjectDetails> data = ProjectDetails().obs;
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
      data.value = args['project'] ?? ProjectDetails();
      projectStatus.value = args['status'];
    }

    if (data.value.milestones != null && data.value.milestones!.isNotEmpty) {
      milestones(data.value.milestones);
      if (selectedMilestoneId.value.isEmpty) {
        selectedMilestoneId.value =
            _defaultMilestoneId(data.value.milestones) ?? "";
      }
    }
    saveToLocalDb();
  }

  void saveToLocalDb() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;
    await dbRepo.saveProject(data.value, userId);
  }

  Future<void> onCaptureVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 1),
    );

    if (video != null) {
      videoPath.value = video.path;
      finalVideoPath = video.path;
    }
  }

  Future<Directory> offlineMediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/offline_media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  Future<File> compressIfNeeded(File file) async {
    final bytes = await file.length();

    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

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

    final rawBaseUrl = NetworkConstants.baseUrl.replaceFirst('baseUrl=', '').trim();
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
    return _defaultMilestoneId(data.value.milestones) ?? "";
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
      milestoneId: "",
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
      final milestoneId = effectiveMilestoneId;
      if (milestoneId.isEmpty) {
        showErrorDialog(
          Get.context!,
          message: "No milestone found for project",
        );
        return;
      }

      showAlertCustom(backBtnDisable: true, title: "Uploading...");

      final modelData = await repo.uploadMilestoneFiles(
        projectId: data.value.id ?? '',
        milestoneId: "",
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
}
