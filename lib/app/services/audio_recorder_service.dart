import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final AudioRecorder _record = AudioRecorder();

  DateTime? _recordingStartTime;

  Future<bool> _hasPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<String> _generateFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}/audio');

    if (!folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    return '${folder.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<String?> startRecording() async {
    if (!await _hasPermission()) return null;

    final path = await _generateFilePath();

    _recordingStartTime = DateTime.now();

    await _record.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 44100,
      ),
      path: path,
    );

    return path;
  }

  Future<int?> stopRecording() async {
    if (!await _record.isRecording()) return null;

    await _record.stop();

    if (_recordingStartTime == null) return null;

    final duration = DateTime.now()
        .difference(_recordingStartTime!)
        .inMilliseconds;

    _recordingStartTime = null;

    return duration;
  }

  Future<void> dispose() async {
    await _record.dispose();
  }
}
