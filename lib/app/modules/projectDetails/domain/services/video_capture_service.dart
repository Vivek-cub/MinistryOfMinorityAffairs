import 'dart:io';

abstract class VideoCaptureService {
  Future<File?> captureFromCamera({Duration maxDuration});
}
