import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_capture_service.dart';

class ImagePickerVideoCaptureService implements VideoCaptureService {
  final ImagePicker _picker;

  ImagePickerVideoCaptureService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  @override
  Future<File?> captureFromCamera({
    Duration maxDuration = const Duration(minutes: 2),
  }) async {
    final video = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: maxDuration,
    );

    if (video == null) return null;
    return File(video.path);
  }
}
