import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_compressor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FfmpegVideoCompressor implements VideoCompressor {
  static const int maxSizeBytes = 20 * 1024 * 1024;

  @override
  Future<File> compressIfNeeded(
    File file, {
    VoidCallback? onCompressionStarted,
  }) async {
    final originalSize = await file.length();

    debugPrint(
      'Original video size: '
      '${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB',
    );

    // No compression required
    if (originalSize <= maxSizeBytes) {
      return file;
    }

    onCompressionStarted?.call();

    final tempDir = await _offlineMediaDir();

    final compressionLevels = [
      const VideoCompressionLevel(
        width: 640,
        bitrate: '700k',
        audioBitrate: '64k',
        fps: 24,
      ),
      const VideoCompressionLevel(
        width: 640,
        bitrate: '500k',
        audioBitrate: '48k',
        fps: 24,
      ),
      const VideoCompressionLevel(
        width: 480,
        bitrate: '350k',
        audioBitrate: '32k',
        fps: 22,
      ),
      const VideoCompressionLevel(
        width: 360,
        bitrate: '250k',
        audioBitrate: '24k',
        fps: 20,
      ),
    ];

    File? lastCompressedFile;

    for (int i = 0; i < compressionLevels.length; i++) {
      final level = compressionLevels[i];

      final outputPath = p.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}_$i.mp4',
      );

      final command = level.toFfmpegCommand(
        inputPath: file.path,
        outputPath: outputPath,
      );

      debugPrint(
        'Compressing video - '
        'Level ${i + 1}, '
        'Bitrate ${level.bitrate}',
      );

      debugPrint('FFmpeg command: $command');

      try {
        debugPrint('BEFORE FFmpegKit.execute');

        final session = await FFmpegKit.execute(command);

        debugPrint('AFTER FFmpegKit.execute');

        final returnCode = await session.getReturnCode();

        debugPrint('FFmpeg return code: $returnCode');

        final logs = await session.getAllLogs();

        for (final log in logs) {
          debugPrint('FFmpeg: ${log.getMessage()}');
        }

        if (returnCode == null || !returnCode.isValueSuccess()) {
          debugPrint('FFmpeg failed at compression level ${i + 1}');

          final logs = await session.getAllLogs();

          for (final log in logs) {
            debugPrint(log.getMessage());
          }

          continue;
        }

        final tempFile = File(outputPath);

        if (!await tempFile.exists()) {
          debugPrint('Compressed file does not exist');
          continue;
        }

        final size = await tempFile.length();

        debugPrint(
          'Compressed size: '
          '${(size / (1024 * 1024)).toStringAsFixed(2)} MB',
        );

        lastCompressedFile = tempFile;

        if (size <= maxSizeBytes) {
          debugPrint('Compression successful below 20 MB');
          return tempFile;
        }
      } catch (e, stackTrace) {
        debugPrint('Compression error at level ${i + 1}: $e');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    // If no compression level could bring the video below 20 MB,
    // return the smallest compressed file generated.
    return lastCompressedFile ?? file;
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
    return '-y '
        '-i "$inputPath" '
        '-vf "scale=$width:-2,fps=$fps" '
        '-c:v libx264 '
        '-preset veryfast '
        '-b:v $bitrate '
        '-maxrate $bitrate '
        '-bufsize 1000k '
        '-c:a aac '
        '-b:a $audioBitrate '
        '-movflags +faststart '
        '"$outputPath"';
  }
}
