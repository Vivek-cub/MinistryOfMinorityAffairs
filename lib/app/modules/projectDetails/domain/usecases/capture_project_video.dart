import 'dart:io';

import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_capture_service.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/services/video_compressor.dart';

class CaptureProjectVideo {
  final VideoCaptureService captureService;
  final VideoCompressor compressor;

  CaptureProjectVideo({
    required this.captureService,
    required this.compressor,
  });

  Future<File?> call({
    Duration maxDuration = const Duration(minutes: 2),
    void Function()? onCompressionStarted,
  }) async {
    final video = await captureService.captureFromCamera(
      maxDuration: maxDuration,
    );

    if (video == null) return null;

    onCompressionStarted?.call();
    return compressor.compressIfNeeded(video);
  }
}
