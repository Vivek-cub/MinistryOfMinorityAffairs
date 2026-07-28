import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/controller/project_functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/data/repo/project_functional_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/ffmpeg_video_compressor.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/services/image_picker_video_capture_service.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/usecases/capture_project_video.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class ProjectFunctionalBinding extends Bindings {
  @override
  void dependencies() {
    final captureProjectVideo = CaptureProjectVideo(
      captureService: ImagePickerVideoCaptureService(),
      compressor: FfmpegVideoCompressor(),
    );
    final dao = SubmissionDao(Get.find<AppDatabase>());
    final repository = SubmissionRepository(dao);

    Get.lazyPut<ProjectFunctionalController>(
      () => ProjectFunctionalController(
        captureProjectVideo,
        ProjectFunctionalRepoImpl(Get.find<ApiService>()),
        repository,
        Get.find<AuthService>(),
      ),
    );
  }
}
