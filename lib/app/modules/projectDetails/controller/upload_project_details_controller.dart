import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
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
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/geofence_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_permission_service.dart';
import 'package:ministry_of_minority_affairs/app/services/location_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import 'package:native_exif/native_exif.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class UploadProjectDetailsController extends GetxController
    with SnackBarMixin, PopupMixin {
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final AuthService authService;
  ProjectRepository dbRepo;

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
  );
  Rx<ProjectDetails> data = ProjectDetails().obs;
  RxString videoPath = "".obs;
  String? audioPath = "";
  String? finalVideoPath = "";
  RxString selectedProgress = ''.obs;
  RxBool isSelectedProgress = false.obs;
  RxDouble userLat = 0.0.obs;
  RxDouble userLng = 0.0.obs;
  RxString selectedMilestoneId = "".obs;
  RxInt statusProgressValue = 0.obs;
  RxString projectStatus = "".obs;

  @override
  void onInit() {
    super.onInit();
    _initializeProjectData();
    // checkGeoFence();
  }

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
            // for (
            //   int j = 0;
            //   j < data.value.milestones![i].imageAtt!.length &&
            //       i < photos.length;
            //   j++
            // ) {
            //   photos[j] = data.value.milestones![i].imageAtt![j];
            // }
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

  Future<void> takePhoto(int index) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100, // capture full quality
      );

      if (image == null) return;

      // 🔑 Convert XFile → File
      final File originalFile = File(image.path);

      final File finalFile = await compressIfNeeded(originalFile);

      final position = await LocationService.getAccurateLocation();

      await addExifData(
        finalFile.path,
        lat: position.latitude,
        lng: position.longitude,
        time: DateTime.now().toString(),
      );

      photos[index] = finalFile.path;
      readExif(finalFile.path);

      final sizeKb = (await finalFile.length()) / 1024;
      debugPrint('📸 Final image size: ${sizeKb.toStringAsFixed(2)} KB');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to take photo',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void showPhotoSourceDialog(int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Photo Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                takePhoto(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  List<String> get selectedImages => photos.whereType<String>().toList();

  Future<String?> getAudioPath() async {
    final rawPath = Get.find<AudioRecorderController>().filePath.value;

    if (rawPath == null || rawPath.isEmpty) return null;

    final File originalAudio = File(rawPath);
    final File finalAudio = await compressAudioIfNeeded(originalAudio);

    return finalAudio.path;
  }

  void onMicrophoneTap() {
    Get.snackbar(
      'Voice Input',
      'Voice input feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
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
      projectId: data.value.id ?? '',
      milestoneId: selectedMilestoneId.value,
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

    if (showMessage) {
      Get.snackbar(
        'Saved Offline',
        'No internet. Data will sync automatically',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    _refreshHomeIfAvailable();
    Get.back(result: true);
    Get.offAll(AppRoutes.home);
  }

  void submitOnline() async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Uploading...");
      final modelData = await repo.uploadMilestoneFiles(
        projectId: data.value.id ?? '',
        milestoneId: selectedMilestoneId.value,
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
        Get.back();
        showSuccessDialog(
          Get.context!,
          message: "Your data is submitted successfully",
          onPressed: () async {
            _refreshHomeIfAvailable();
            Get.offAllNamed(AppRoutes.home);
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

  RxBool isInsideFence = false.obs;

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

  // Check Internet
  Future<void> submitData() async {
    audioPath = await getAudioPath();
    final rawVideoPath = videoPath.value;

    // if (rawVideoPath != null && rawVideoPath.isNotEmpty) {
    //   final File originalVideo = File(rawVideoPath);
    //   final File compressedVideo = await compressVideoIfNeeded(originalVideo);

    //   finalVideoPath = compressedVideo.path;
    // }

    final hasInternet = await NetworkService.hasInternet();

    if (photos.every((photo) => photo == null || photo.isEmpty)) {
      showErrorDialog(Get.context!, message: "Please Upload Images");
      return;
    }

    // if (isLastPendingMilestone &&
    //     (finalVideoPath == null || finalVideoPath!.isEmpty)) {
    //   showErrorDialog(Get.context!, message: "Please Upload Video");
    //   return;
    // }

    if (selectedProgress.value == "") {
      showErrorDialog(Get.context!, message: "Please Select Project Status");
      return;
    }
    if (statusProgressValue.value == 0) {
      showErrorDialog(
        Get.context!,
        message: "Please select progress of your project",
      );
      return;
    }

    // if (audioPath == "" || audioPath == null) {
    //   showErrorDialog(Get.context!, message: "Please Upload Audio");
    //   return;
    // }

    // await processImagesWithExif();

    if (hasInternet) {
      submitOnline();
    } else {
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
  }

  Future<File> compressIfNeeded(File file) async {
    final bytes = await file.length();

    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await offlineMediaDir();
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

  Future<File> compressAudioIfNeeded(File file) async {
    final bytes = await file.length();

    // ✅ If already <= 1 MB
    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await offlineMediaDir();
    final outputPath = p.join(
      tempDir.path,
      'compressed_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    // 🎯 FFmpeg command
    // - AAC codec
    // - 64 kbps bitrate (good voice quality, very small size)
    final command =
        '-y -i "${file.path}" -map 0:a -ac 1 -b:a 64k "$outputPath"';

    await FFmpegKit.execute(command);

    final compressedFile = File(outputPath);

    // fallback if compression failed
    if (!compressedFile.existsSync()) {
      return file;
    }

    final newSize = await compressedFile.length();

    // If still > 1 MB, fallback
    if (newSize > 1024 * 1024) {
      return file;
    }

    return compressedFile;
  }

  Future<void> onCaptureVideo() async {
    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 1),
    );

    if (video != null) {
      videoPath.value = video.path;
    }
  }

  Future<File> compressVideoIfNeeded(File file) async {
    final int maxSize = 2 * 1024 * 1024; // 2 MB
    final int originalSize = await file.length();

    // ✅ Already small enough
    if (originalSize <= maxSize) {
      return file;
    }

    final tempDir = await offlineMediaDir();
    final outputPath = p.join(
      tempDir.path,
      'compressed_video_${DateTime.now().millisecondsSinceEpoch}.mp4',
    );

    // 🎯 FFmpeg command
    // - scale video
    // - reduce bitrate
    // - keep reasonable audio
    final command = '''
-y -i "${file.path}"
-vf scale='min(640,iw)':-2
-c:v libx264 -preset veryfast -b:v 500k
-c:a aac -b:a 64k
-movflags +faststart
"$outputPath"
''';

    await FFmpegKit.execute(command);

    final compressedFile = File(outputPath);

    if (!compressedFile.existsSync()) {
      return file; // fallback
    }

    final compressedSize = await compressedFile.length();

    // If still > 2 MB, fallback to original
    if (compressedSize > maxSize) {
      return file;
    }

    return compressedFile;
  }

  bool isSelected(String id) {
    return selectedMilestoneId.value == id;
  }

  void selectProgress(String value) {
    selectedProgress.value = value;
  }

  Future<Directory> offlineMediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/offline_media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }

  bool get isLastPendingMilestone {
    final milestones = data.value.milestones ?? [];
    final incomplete =
        milestones.where((m) => m.status != "Completed").toList();
    if (incomplete.isEmpty) return false;
    return incomplete.last.id == selectedMilestoneId.value;
  }

  void _refreshHomeIfAvailable() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.checkInternet();
    }
  }

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

  Future<void> addExifData(
    String path, {
    double? lat,
    double? lng,
    String? time,
  }) async {
    final exif = await Exif.fromPath(path);

    String userId = await authService.getUserId() ?? "";

    String formatDate(String? input) {
      if (input == null || input.isEmpty) return "";
      final date = DateTime.parse(input);
      return "${date.year}:${date.month.toString().padLeft(2, '0')}:${date.day.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    }

    /// Convert decimal to DMS
    List<String> toDMS(double coord) {
      final abs = coord.abs();
      final deg = abs.floor();
      final minFloat = (abs - deg) * 60;
      final min = minFloat.floor();
      final sec = ((minFloat - min) * 60);

      return ["$deg/1", "$min/1", "${(sec * 100).round()}/100"];
    }

    Map<String, String> attributes = {
      "DateTimeOriginal": formatDate(time),
      "UserComment": "UserId:$userId",
    };

    if (lat != null && lng != null) {
      attributes.addAll({
        "GPSLatitude": lat.toString(),
        "GPSLatitudeRef": lat >= 0 ? "N" : "S",
        "GPSLongitude": lng.toString(),
        "GPSLongitudeRef": lng >= 0 ? "E" : "W",
      });
    }

    await exif.writeAttributes(attributes);
    await exif.close();
  }

  Future<void> processImagesWithExif() async {
    for (String path in selectedImages) {
      // await addExifData(path);
    }
  }

  Future<void> readExif(String path) async {
    final exif = await Exif.fromPath(path);

    if (exif == null) {
      print("No EXIF found");
      return;
    }

    final attributes = await exif.getAttributes();

    attributes?.forEach((key, value) {
      print("print $key : $value");
    });

    await exif.close();
  }
}
