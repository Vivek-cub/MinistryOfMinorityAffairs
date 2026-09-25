import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/repo/functional_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/ffmpeg_video_compressor.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/image_picker_video_capture_service.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class FunctionalBinding extends Bindings {
  @override
  void dependencies() {
    final captureProjectVideo = CaptureProjectVideo(
      captureService: ImagePickerVideoCaptureService(),
      compressor: FfmpegVideoCompressor(),
    );
    final dao = SubmissionDao(Get.find<AppDatabase>());
    final repository = SubmissionRepository(dao);

    Get.lazyPut<FunctionalController>(
      () => FunctionalController(
        captureProjectVideo,
        FunctionalRepoImpl(Get.find<ApiService>()),
        repository,
        Get.find<AuthService>(),
      ),
    );
  }
}
