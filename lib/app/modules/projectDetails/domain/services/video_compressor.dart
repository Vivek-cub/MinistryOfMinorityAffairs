import 'dart:io';
import 'dart:ui';

abstract class VideoCompressor {
  Future<File> compressIfNeeded(
    File file, {
    VoidCallback? onCompressionStarted,
  });
}
