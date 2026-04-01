import 'dart:io';

import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_permission_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Work Detail controller
/// Manages state and business logic for Work Detail screen
class WorkDetailController extends GetxController
    with SnackBarMixin, PopupMixin {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;

  final photos = <String?>[null, null, null].obs;

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
    }

    if (data.value.milestones != null || data.value.milestones!.isNotEmpty) {
      milestones(data.value.milestones);
    }
    saveToLocalDb();
  }

  void saveToLocalDb() async {
    final userId = await authService.getUserId();
    if (userId == null || userId.isEmpty) return;
    await dbRepo.saveProject(data.value, userId);
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

  void selectMilestone(String id) {
    selectedMilestoneId.value = id;
  }

  bool isSelected(String id) {
    return selectedMilestoneId.value == id;
  }
}
