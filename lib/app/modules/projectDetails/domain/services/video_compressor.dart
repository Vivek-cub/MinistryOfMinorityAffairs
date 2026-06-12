import 'dart:io';

abstract class VideoCompressor {
  Future<File> compressIfNeeded(File file);
}
