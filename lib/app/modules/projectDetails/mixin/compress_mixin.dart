import 'dart:io';
import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import 'package:path/path.dart' as p;

mixin CompressMixin {
  Future<File> compressImageIfNeeded(File file) async {
    final bytes = await file.length();

    // Already below 1 MB
    if (bytes <= 1024 * 1024) {
      return file;
    }

    final tempDir = await Helpers().offlineMediaDir();

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

    final tempDir = await Helpers().offlineMediaDir();

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
}
