import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/ffmpeg_video_compressor.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/image_picker_video_capture_service.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';

class ProjectFunctionalBinding extends Bindings {
  @override
  void dependencies() {
    final captureProjectVideo = CaptureProjectVideo(
      captureService: ImagePickerVideoCaptureService(),
      compressor: FfmpegVideoCompressor(),
    );

    Get.lazyPut<ProjectFunctionalController>(
      () => ProjectFunctionalController(captureProjectVideo),
    );
  }
}
