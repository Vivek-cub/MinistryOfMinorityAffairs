import 'dart:io';

import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_compressor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FfmpegVideoCompressor implements VideoCompressor {
  static const int maxSizeBytes = 5 * 1024 * 1024;

  @override
  Future<File> compressIfNeeded(
    File file, {
    VoidCallback? onCompressionStarted,
  }) async {
    final originalSize = await file.length();

    debugPrint(
      "Original video size: "
      "${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB",
    );

    if (originalSize <= maxSizeBytes) {
      return file;
    }

    onCompressionStarted?.call();

    final tempDir = await _offlineMediaDir();

    final compressionLevels = [
      const VideoCompressionLevel(
        width: 960,
        bitrate: '700k',
        audioBitrate: '64k',
        fps: 24,
      ),
      const VideoCompressionLevel(
        width: 720,
        bitrate: '500k',
        audioBitrate: '48k',
        fps: 24,
      ),
      const VideoCompressionLevel(
        width: 640,
        bitrate: '350k',
        audioBitrate: '32k',
        fps: 22,
      ),
      const VideoCompressionLevel(
        width: 480,
        bitrate: '250k',
        audioBitrate: '24k',
        fps: 20,
      ),
    ];

    File? compressedFile;

    for (int i = 0; i < compressionLevels.length; i++) {
      final level = compressionLevels[i];
      final outputPath = p.join(
        tempDir.path,
        'compressed_${i}_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      final command = level.toFfmpegCommand(
        inputPath: file.path,
        outputPath: outputPath,
      );

      debugPrint(
        "Original Compressing video "
        "Level ${i + 1} "
        "Bitrate ${level.bitrate}",
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

      if (size <= maxSizeBytes) {
        debugPrint("Original Compression successful below 5 MB");
        return compressedFile;
      }
    }

    return compressedFile ?? file;
  }

  Future<Directory> _offlineMediaDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${dir.path}/offline_media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return mediaDir;
  }
}

class VideoCompressionLevel {
  final int width;
  final String bitrate;
  final String audioBitrate;
  final int fps;

  const VideoCompressionLevel({
    required this.width,
    required this.bitrate,
    required this.audioBitrate,
    required this.fps,
  });

  String toFfmpegCommand({
    required String inputPath,
    required String outputPath,
  }) {
    return '''
-y -i "$inputPath"
-vf scale='min($width,iw)':-2,fps=$fps
-c:v libx264
-preset veryfast
-b:v $bitrate
-maxrate $bitrate
-bufsize 1000k
-c:a aac
-b:a $audioBitrate
-movflags +faststart
"$outputPath"
''';
  }
}
