import 'dart:async';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
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
    final path = await _service.startRecording();
    if (path == null) return;

    filePath.value = path;
    durationMs.value = 0;
    isRecording.value = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if(durationMs.value>9000){
      _stopRecording();
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

  @override
  void onClose() {
    _timer?.cancel();
    _player.dispose();
    _service.dispose();
    super.onClose();
  }
}
