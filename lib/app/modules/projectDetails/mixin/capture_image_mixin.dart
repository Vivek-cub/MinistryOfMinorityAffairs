import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/mixin/compress_mixin.dart';

mixin CaptureImageMixin on CompressMixin {
  Future<File?> captureImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100, // capture full quality
    );

    if (image == null) return null;

    // 🔑 Convert XFile → File
    final File originalFile = File(image.path);

    final File finalFile = await compressImageIfNeeded(originalFile);
    return finalFile;
  }
}
