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
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';
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
  // RxString selectedMilestoneId = "".obs;
  RxInt statusProgressValue = 0.obs;
  RxString projectStatus = "".obs;
  RxBool isLocked = false.obs;

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

    saveToLocalDb();
  }

  void saveToLocalDb() async {
    final userId = await authService.getUserToken();
    if (userId == null || userId.isEmpty) return;
    await dbRepo.saveProject(data.value, userId);
  }

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

      photos[index] = finalFile.path;
      photos.refresh();

      try {
        final position = await LocationService.getAccurateLocation();

        await addExifData(
          finalFile.path,
          lat: position.latitude,
          lng: position.longitude,
          time: DateTime.now().toString(),
        );

        await readExif(finalFile.path);
      } catch (e) {
        debugPrint('Failed to add image EXIF data: $e');
      }

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

    _refreshHomeIfAvailable();
    Get.offAllNamed(AppRoutes.home);

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
        projectId: data.value.id ?? '',
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

    // Already below 1 MB
    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await offlineMediaDir();

    File? compressedFile;

    for (int quality = 85; quality >= 30; quality -= 10) {
      final targetPath = p.join(
        tempDir.path,
        'compressed_${quality}_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
        minWidth: 1280,
        minHeight: 1280,
        format: CompressFormat.jpeg,
      );

      if (result == null) continue;

      final compressed = File(result.path);

      final size = await compressed.length();

      if (size <= 1024 * 1024) {
        compressedFile = compressed;
        break;
      }

      compressedFile = compressed;
    }

    return compressedFile ?? file;
  }

  Future<File> compressAudioIfNeeded(File file) async {
    final bytes = await file.length();

    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await offlineMediaDir();

    final outputPath = p.join(
      tempDir.path,
      'compressed_audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );

    final command =
        '-y -i "${file.path}" -ac 1 -c:a aac -b:a 64k "$outputPath"';

    await FFmpegKit.execute(command);

    final compressedFile = File(outputPath);

    if (!compressedFile.existsSync()) {
      return file;
    }

    return compressedFile;
  }

  // bool isSelected(String id) {
  //   return selectedMilestoneId.value == id;
  // }

  void selectProgress(String value) {
    selectedProgress.value = value;
    if (selectedProgress.value == "NotStarted") {
      statusProgressValue(0);
      isLocked(true);
    } else if (selectedProgress.value == "Completed") {
      statusProgressValue(100);
      isLocked(true);
    } else {
      isLocked(false);
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

  // bool get isLastPendingMilestone {
  //   final milestones = data.value.milestones ?? [];
  //   final incomplete =
  //       milestones.where((m) => m.status != "Completed").toList();
  //   if (incomplete.isEmpty) return false;
  //   return incomplete.last.id == selectedMilestoneId.value;
  // }

  void _refreshHomeIfAvailable() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.checkInternet();
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
        projectId: data.value.id ?? '',
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
    final insideGeofence = await checkGeoFence(
      data.value.lat ?? 0.0,
      data.value.lng ?? 0.0,
    );

    if (!insideGeofence) {
      showErrorDialog(Get.context!, message: "You are outside the location");
      return;
    }

    final picker = ImagePicker();
    final XFile? video = await picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(minutes: 2),
    );

    if (video != null) {
      showAlertCustom(backBtnDisable: true, title: "Loading...");
      final compressedFile = await compressVideoIfNeeded(File(video.path));

      videoPath.value = compressedFile.path;
      finalVideoPath = compressedFile.path;
      Get.back();
    }
  }

  Future<File> compressVideoIfNeeded(File file) async {
    const int maxSize = 5 * 1024 * 1024;

    final originalSize = await file.length();

    debugPrint(
      "Original video size: "
      "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
    );

    if (originalSize <= maxSize) {
      return file;
    }

    final tempDir = await offlineMediaDir();

    final compressionLevels = [
      {'width': 960, 'bitrate': '700k', 'audioBitrate': '64k', 'fps': 24},
      {'width': 720, 'bitrate': '500k', 'audioBitrate': '48k', 'fps': 24},
      {'width': 640, 'bitrate': '350k', 'audioBitrate': '32k', 'fps': 22},
      {'width': 480, 'bitrate': '250k', 'audioBitrate': '24k', 'fps': 20},
    ];

    File? compressedFile;

    for (int i = 0; i < compressionLevels.length; i++) {
      final level = compressionLevels[i];

      final outputPath = p.join(
        tempDir.path,
        'compressed_${i}_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      final command = '''
-y -i "${file.path}"
-vf scale='min(${level['width']},iw)':-2,fps=${level['fps']}
-c:v libx264
-preset veryfast
-b:v ${level['bitrate']}
-maxrate ${level['bitrate']}
-bufsize 1000k
-c:a aac
-b:a ${level['audioBitrate']}
-movflags +faststart
"$outputPath"
''';

      debugPrint(
        "Original Compressing video "
        "Level ${i + 1} "
        "Bitrate ${level['bitrate']}",
      );

      await FFmpegKit.execute(command);

      final tempFile = File(outputPath);

      if (!tempFile.existsSync()) {
        continue;
      }

      final size = await tempFile.length();

      debugPrint(
        "Original Compressed size: "
        "${(size / (1024 * 1024)).toStringAsFixed(2)} MB",
      );

      compressedFile = tempFile;

      if (size <= maxSize) {
        debugPrint("Original Compression successful below 5 MB");
        return compressedFile;
      }
    }

    return compressedFile ?? file;
  }

  void clearVideoSelection() {
    videoPath.value = "";
    finalVideoPath = "";
  }
}
