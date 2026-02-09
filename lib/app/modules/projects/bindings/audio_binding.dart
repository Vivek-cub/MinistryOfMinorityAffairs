
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/audio_recorder_controller.dart';

class AudioBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AudioRecorderController());
  }
}
