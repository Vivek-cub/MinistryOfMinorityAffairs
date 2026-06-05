import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/services/audio_recorder_service.dart';

class AudioRecorderController extends GetxController {
  final AudioRecorderService _service = AudioRecorderService();
  final AudioPlayer _player = AudioPlayer();

  final isRecording = false.obs;
  final isPlaying = false.obs;

  final filePath = RxnString();
  final durationMs = 0.obs;

  Timer? _timer;

  /// Start / stop recording
  Future<void> toggleRecording() async {
    if (isRecording.value) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (filePath.value != null) {
      Get.snackbar(
        'Audio already recorded',
        'Only one audio can be recorded at a time. Delete the existing audio to record again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning,
      );
      return;
    }

    final path = await _service.startRecording();
    if (path == null) return;

    filePath.value = path;
    durationMs.value = 0;
    isRecording.value = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (durationMs.value >= 60000) {
        _stopRecording();
        Get.snackbar(
          'Recording Stopped',
          'Maximum recording duration is 1 minute.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }
      durationMs.value += 1000;
    });
  }

  Future<void> _stopRecording() async {
    await _service.stopRecording();
    _timer?.cancel();
    isRecording.value = false;
  }

  /// Play recorded audio
  Future<void> play() async {
    if (filePath.value == null) return;

    isPlaying.value = true;
    await _player.play(DeviceFileSource(filePath.value!));
    _player.onPlayerComplete.listen((_) {
      isPlaying.value = false;
    });
  }

  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
  }

  Future<void> deleteRecording() async {
    final path = filePath.value;
    if (path == null) return;

    await stop();

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    filePath.value = null;
    durationMs.value = 0;
  }

  @override
  void onClose() {
    _timer?.cancel();
    _player.dispose();
    _service.dispose();
    super.onClose();
  }
}
