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
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/audio_recorder_controller.dart';
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
class WorkDetailController extends GetxController with SnackBarMixin, PopupMixin{
  final SubmissionRepository repository;
  final ProjectDetailRepo repo;
  final AuthService authService;

  final photos = <String?>[null, null, null].obs;

  // Remarks controller
  final remarksController = TextEditingController();

  // Loading state
  final isSubmitting = false.obs;

  WorkDetailController(this.repository,this.repo,this.authService);
  Rx<ProjectDetails> data = ProjectDetails().obs;
  RxString videoPath ="".obs; 
  String? audioPath="";
  String? finalVideoPath="";
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
  
    if(data.value.milestones !=null || data.value.milestones!.isNotEmpty){
      milestones(data.value.milestones);
    }
    //saveToLocalDb();
    
  }

  // void saveToLocalDb()async{
  //       final projectDao = Get.find<ProjectDao>();
  //       await projectDao.saveProject(data.value);
  // }
  

  // Future<void> takePhoto(int index) async {
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? image = await picker.pickImage(
  //       source: ImageSource.camera,
  //       imageQuality: 85,
  //     );

  //     if (image != null) {
  //       photos[index] = image.path;
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to take photo: ${e.toString()}',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

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

  List<String> get selectedImages =>
    photos.whereType<String>().toList();



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
  await repository.save(
    projectId: data.value.id ?? '',
    milestoneId: selectedMilestoneId.value,
    images: photos.whereType<String>().toList(),
    audioPath: audioPath,
    audioDuration: Get.find<AudioRecorderController>().durationMs.value,
    videoPath: finalVideoPath,
    remarks: remarksController.text,
    isSynced: false,
  );

  if (showMessage) {
    Get.snackbar(
      'Saved Offline',
      'No internet. Data will sync automatically',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Get.back(result: true);
}

  void submitOnline() async{
    
  try {
      showAlertCustom(
        backBtnDisable: true,
        title: "Uploading..."
      );
      final modelData = await repo.uploadMilestoneFiles(
        projectId: data.value.id ?? '',
          milestoneId: selectedMilestoneId.value,
          imagePaths: selectedImages,
          videoPath: finalVideoPath,
          audioPath: audioPath,
      );
        
        if (modelData.statusCode == '200') {
          Get.back();
          showSuccessDialog(
            Get.context!,
            message: "Your data is submitted successfully",
            onPressed: (){
                Get.offNamed(AppRoutes.home);
          });
      }else {
        showErrorDialog(Get.context!,
            title: "Error",
            message: modelData.error ?? "Something went wrong.",
            onPressed: () async {
          Get.back();
        });
      }
    } catch (e) {
      Get.back();
      //debugPrint(e.toString());
    } finally {
      
    }
  }

  @override
  void onClose() {
    remarksController.dispose();
    super.onClose();
  }

RxBool isInsideFence = false.obs;

  Future<bool> checkGeoFence(double lat,double lng) async {
    final granted = await LocationPermissionService.request();
    if (!granted) return false;

    final position = await LocationService.getAccurateLocation();
    if(lat == 0.0 && lng==0.0) return true;

    isInsideFence.value = GeoFenceService.isInside(
      user: position,
      targetLat: lat,
      targetLng: lng,
      radius: 1000,
    );

    debugPrint(position.latitude.toString()+" "+position.longitude.toString());

    if(isInsideFence.value==true){
      debugPrint("Inside geo fence loaction");
      return true;
    }else{
      debugPrint("Outside geo fence loaction");
      return false;
    }
  }

  Future<bool> isMockLocation(Position position) async {
  return position.isMocked;
}

// Check Internet
Future<void> submitData()  async {
  if (isSubmitting.value) return;
  isSubmitting.value = true;
  audioPath = await getAudioPath();
  final rawVideoPath = videoPath.value;



if (rawVideoPath != null && rawVideoPath.isNotEmpty) {
  final File originalVideo = File(rawVideoPath);
  final File compressedVideo =
      await compressVideoIfNeeded(originalVideo);

  finalVideoPath = compressedVideo.path;
}

  final hasInternet = await NetworkService.hasInternet();
  if(selectedMilestoneId.value.isEmpty){
    showErrorDialog(
      Get.context!,
      message: "Please Select Milestone"
    );
    return;
  }

  if (hasInternet) {
     submitOnline();
  } else {
    await saveOffline();
  }

  isSubmitting.value = false;
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
    final XFile? result =
        await FlutterImageCompress.compressAndGetFile(
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

  final tempDir = await getTemporaryDirectory();
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

  final tempDir = await getTemporaryDirectory();
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

void selectMilestone(String id) {
    selectedMilestoneId.value = id;
  }

  bool isSelected(String id) {
    return selectedMilestoneId.value == id;
  }


}
