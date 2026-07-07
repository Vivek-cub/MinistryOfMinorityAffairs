import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/capture_image_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/geofence_mixin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';

class UploadProjectDetailsController extends GetxController
    with
        SnackBarMixin,
        PopupMixin,
        CompressMixin,
        CaptureImageMixin,
        GeofenceMixin {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;
  final CaptureProjectVideo captureProjectVideo;

  final photos = List<String?>.filled(3, null).obs;

  // Remarks controller
  final remarksController = TextEditingController();

  // Loading state
  final isSubmitting = false.obs;

  UploadProjectDetailsController(
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
  RxString selectedProgress = ''.obs;
  RxBool isSelectedProgress = false.obs;
  @override
  RxDouble userLat = 0.0.obs;
  @override
  RxDouble userLng = 0.0.obs;
  @override
  RxBool isInsideFence = false.obs;

  // RxString selectedMilestoneId = "".obs;
  RxInt statusProgressValue = 0.obs;
  RxString projectStatus = "".obs;
  RxBool isLocked = false.obs;
  RxString projectOrUnitId = "".obs;
  final RxnBool isFunctionalProject = RxnBool();
  UserProject? userProject;

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
      projectOrUnitId.value = args["id"];
      userProject = args["userProject"];
    }

    saveToLocalDb();
  }

  void saveToLocalDb() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;
    await dbRepo.saveProject(data.value, userId);
  }

  Future<void> takePhoto(int index) async {
    try {
      debugPrint("1. Before capture");
      final File? image = await captureImage();

      photos[index] = image?.path;
      photos.refresh();
      debugPrint("2. After capture");

      try {
        debugPrint("3. Before location");
        final position = await LocationService.getAccurateLocation();
        debugPrint("4. After location");

        await Helpers().addExifData(
          image?.path ?? "",
          lat: position.latitude,
          lng: position.longitude,
          time: DateTime.now().toString(),
        );
        debugPrint("5. EXIF completed");
        // await readExif(image?.path ?? "");
      } catch (e) {
        debugPrint('Failed to add image EXIF data: $e');
      }

      if (image != null) {
        final sizeKb = await image.length() / 1024;
        debugPrint('📸 Final image size: ${sizeKb.toStringAsFixed(2)} KB');
      }
    } catch (e) {}
  }

  List<String> get selectedImages => photos.whereType<String>().toList();

  Future<String?> getAudioPath() async {
    final rawPath = Get.find<AudioRecorderController>().filePath.value;

    if (rawPath == null || rawPath.isEmpty) return null;

    final File originalAudio = File(rawPath);
    final File finalAudio = await compressAudioIfNeeded(originalAudio);

    return finalAudio.path;
  }

  /// Submit work detail update
  Future<void> saveOffline({bool showMessage = true}) async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) {
      showErrorDialog(Get.context!, message: "Unable to identify current user");
      return;
    }

    await repository.save(
      userId: userId,
      projectId: projectOrUnitId.value,
      images: photos.whereType<String>().toList(),
      audioPath: audioPath,
      audioDuration: Get.find<AudioRecorderController>().durationMs.value,
      videoPath: finalVideoPath,
      remarks: remarksController.text,
      isSynced: false,
      userLat: userLat.value.toString(),
      userLng: userLng.value.toString(),
      progress: statusProgressValue.value.toString(),
      projectStatus: selectedProgress.value,
    );

    Helpers().refreshHomeIfAvailable();
    await _navigateToDashboard();

    if (showMessage) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Saved Offline',
          'No internet. Data will sync automatically',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  void submitOnline() async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Uploading...");
      await _logUploadMediaSizes(
        imagePaths: selectedImages,
        audioPath: audioPath,
        videoPath: finalVideoPath,
        source: 'direct online upload',
      );
      final modelData = await repo.uploadMilestoneFiles(
        projectId: projectOrUnitId.value,
        imagePaths: selectedImages,
        videoPath: finalVideoPath,
        audioPath: audioPath,
        userLat: userLat.value.toString(),
        userLng: userLng.value.toString(),
        progress: statusProgressValue.value.toString(),
        projectStatus: selectedProgress.value,
        remarks: remarksController.text.toString(),
      );

      if (modelData.statusCode == '200') {
        await _cleanupUploadedOnlineMedia();
        Get.back();
        showSuccessDialog(
          Get.context!,
          message: "Your data is submitted successfully",
          onPressed: () async {
            Helpers().refreshHomeIfAvailable();
            await _navigateToDashboard();
          },
        );
      } else {
        showErrorDialog(
          Get.context!,
          title: "Error",
          message: modelData.error ?? "Something went wrong.",
          onPressed: () async {
            Get.back();
          },
        );
      }
    } catch (e) {
      Get.back();
      //debugPrint(e.toString());
    } finally {}
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

  // Check Internet
  Future<void> submitData() async {
    // showAlertCustom(backBtnDisable: true, title: "Preparing...");
    try {
      audioPath = await getAudioPath();
      final rawVideoPath = videoPath.value;

      final hasInternet = await NetworkService.hasInternet();

      if (photos.every((photo) => photo == null || photo.isEmpty)) {
        showErrorDialog(Get.context!, message: "Please Upload Images");
        return;
      }

      if (selectedProgress.value == "") {
        showErrorDialog(Get.context!, message: "Please Select Project Status");
        return;
      }
      // if (statusProgressValue.value == 0) {
      //   showErrorDialog(
      //     Get.context!,
      //     message: "Please select progress of your project",
      //   );
      //   return;
      // }
      if (selectedProgress.value == "Completed" &&
          isFunctionalProject.value == null) {
        showErrorDialog(
          Get.context!,
          message: "Please select Is this project functional or not",
        );
        return;
      }

      if (isFunctionalProject.value == true && finalVideoPath == "") {
        showErrorDialog(Get.context!, message: "Please upload video");
        return;
      }

      if (projectOrUnitId.value.isEmpty) {
        projectOrUnitId.value = data.value.id ?? "";
      }

      if (hasInternet) {
        // Get.back();
        submitOnline();
      } else {
        //Get.back();
        showMessageDialog(
          Get.context!,
          title: "NO Internet!",
          message: "Want to save this in Local Database?",
          onPressed: () async {
            await saveOffline();
          },
        );
      }

      isSubmitting.value = false;
    } catch (e) {
      // Get.back();
    }
  }

  void selectProgress(String value) {
    selectedProgress.value = value;
    if (selectedProgress.value == "Not Started") {
      statusProgressValue(0);
      isLocked(true);
    } else if (selectedProgress.value == "Completed") {
      statusProgressValue(100);
      isLocked(true);
    } else {
      isLocked(false);
    }
  }

  Future<void> _cleanupUploadedOnlineMedia() async {
    final uploadedPaths = <String>[
      ...selectedImages,
      if (audioPath?.isNotEmpty == true) audioPath!,
      if (finalVideoPath?.isNotEmpty == true) finalVideoPath!,
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

    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;

    try {
      await dbRepo.deleteUploadedLocalAttachmentPaths(
        userId: userId,
        projectId: projectOrUnitId.value,
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

  Future<void> onCaptureVideo() async {
    // final insideGeofence = await checkGeoFence(
    //   data.value.lat ?? 0.0,
    //   data.value.lng ?? 0.0,
    // );

    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
    );

    if (insideGeofence == false) {
      //controller.showPhotoSourceDialog(index);
      PopupMixin().showErrorDialog(
        Get.context!,
        message: "You are outside the location",
      );
      return;
    }

    var showedLoading = false;

    try {
      final compressedFile = await captureProjectVideo(
        maxDuration: const Duration(minutes: 2),
        onCompressionStarted: () {
          showedLoading = true;
          // showAlertCustom(backBtnDisable: true, title: "Loading...");
        },
      );

      if (compressedFile == null) return;

      videoPath.value = compressedFile.path;
      finalVideoPath = compressedFile.path;
    } finally {
      // if (showedLoading && (Get.isDialogOpen ?? false)) {
      //   Get.back();
      // }
    }
  }

  void clearVideoSelection() {
    videoPath.value = "";
    finalVideoPath = "";
  }

  Future<void> _navigateToDashboard() async {
    Get.offAllNamed(await authService.dashboardRoute());
  }
}

/*

// Future<void> addExifData(String path) async {
  //   final position = await LocationService.getAccurateLocation();

  //   final exif = await Exif.fromPath(path);

  //   await exif.writeAttributes({
  //     "Make": "PMJVK Nigrani",
  //     "DateTime": DateTime.now().toString(),
  //     "GPSLatitude": position.latitude,
  //     "GPSLongitude": position.longitude,
  //     "UserId": userId,
  //   });

  //   await exif.close();
  // }

  // Future<void> processImagesWithExif() async {
  //   for (String path in selectedImages) {
  //     // await addExifData(path);
  //   }
  // }


  // bool get isLastPendingMilestone {
  //   final milestones = data.value.milestones ?? [];
  //   final incomplete =
  //       milestones.where((m) => m.status != "Completed").toList();
  //   if (incomplete.isEmpty) return false;
  //   return incomplete.last.id == selectedMilestoneId.value;
  // }



   // bool isSelected(String id) {
  //   return selectedMilestoneId.value == id;
  // }




    // if (rawVideoPath != null && rawVideoPath.isNotEmpty) {
    //   final File originalVideo = File(rawVideoPath);
    //   final File compressedVideo = await compressVideoIfNeeded(originalVideo);

    //   finalVideoPath = compressedVideo.path;
    // }


// if (audioPath == "" || audioPath == null) {
    //   showErrorDialog(Get.context!, message: "Please Upload Audio");
    //   return;
    // }

    // await processImagesWithExif();

     // if (isLastPendingMilestone &&
    //     (finalVideoPath == null || finalVideoPath!.isEmpty)) {
    //   showErrorDialog(Get.context!, message: "Please Upload Video");
    //   return;
    // }


    // in Capture Image
    // final ImagePicker picker = ImagePicker();
      // final XFile? image = await picker.pickImage(
      //   source: ImageSource.camera,
      //   imageQuality: 100, // capture full quality
      // );

      // if (image == null) return;

      // // 🔑 Convert XFile → File
      // final File originalFile = File(image.path);

*/

/*

  Future<void> _initializeProjectData() async {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      data.value = args['project'] ?? ProjectDetails();
      projectStatus.value = args['status'];
      selectedMilestoneId.value = args["milestoneId"] ?? "";
      if (data.value.milestones != null) {
        for (int i = 0; i < data.value.milestones!.length; i++) {
          if (selectedMilestoneId.value == data.value.milestones![i].id) {
            statusProgressValue.value = data.value.milestones![i].progress ?? 0;

          }
        }
      }
    }

    // await _loadOfflineDraftIfExists();
  }

  Future<void> _loadOfflineDraftIfExists() async {
    final projectId = data.value.id ?? '';
    final milestoneId = selectedMilestoneId.value;
    final userId = await authService.getUserToken();

    if (projectId.isEmpty || milestoneId.isEmpty) return;
    if (userId == null || userId.isEmpty) return;

    final draft = await repository.getDraftByProjectAndMilestone(
      userId: userId,
      projectId: projectId,
      milestoneId: milestoneId,
    );

    if (draft == null) return;

    final imagePaths = draft.images.map((e) => e.filePath).toList();
    for (int i = 0; i < imagePaths.length && i < photos.length; i++) {
      photos[i] = imagePaths[i];
    }

    audioPath = draft.audio?.filePath ?? "";
    videoPath.value = draft.video?.filePath ?? "";
    finalVideoPath = draft.video?.filePath ?? "";
    remarksController.text = draft.remark?.remarks ?? "";
    selectedProgress.value = draft.submission.projectStatus;
    statusProgressValue.value = int.tryParse(draft.submission.progress) ?? 0;
  }
  */

/*

Future<bool> checkGeoFence(double lat, double lng) async {
    final granted = await LocationPermissionService.request();
    if (!granted) return false;

    final position = await LocationService.getAccurateLocation();
    userLat(position.latitude);
    userLng(position.longitude);

    if (lat == 0.0 && lng == 0.0) return true;

    isInsideFence.value = GeoFenceService.isInside(
      user: position,
      targetLat: lat,
      targetLng: lng,
      radius: 200,
    );

    debugPrint(
      position.latitude.toString() +
          " " +
          position.longitude.toString() +
          "" +
          position.altitude.toString(),
    );

    if (isInsideFence.value == true) {
      debugPrint("Inside geo fence loaction");
      return true;
    } else {
      debugPrint("Outside geo fence loaction");
      return false;
    }
  }

  */
