import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_recorder_controller.dart';

class AudioRecorderWidget extends StatelessWidget {
  AudioRecorderWidget({super.key});

  final AudioRecorderController controller =
      Get.find<AudioRecorderController>();

  String _formatDuration(int ms) {
    final seconds = ms ~/ 1000;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isRecording.value) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.mic, color: Colors.red),
              const SizedBox(width: 8),
              const Text(
                'Recording',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                _formatDuration(controller.durationMs.value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.red),
                onPressed: controller.toggleRecording,
              ),
            ],
          ),
        );
      }

      if (controller.filePath.value != null) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  controller.isPlaying.value
                      ? Icons.stop
                      : Icons.play_arrow,
                  color: Colors.green,
                ),
                onPressed: controller.isPlaying.value
                    ? controller.stop
                    : controller.play,
              ),
              const SizedBox(width: 8),
              const Text(
                'Recorded Audio',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                _formatDuration(controller.durationMs.value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }

      // Nothing yet
      return const SizedBox.shrink();
    });
  }
}
