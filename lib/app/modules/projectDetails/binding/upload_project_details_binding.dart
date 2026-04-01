
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/upload_project_details_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/work_detail_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_detail_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class UploadProjectDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Get project from arguments
    // final arguments = Get.arguments;

    // ProjectModel project;

    // if (arguments == null || arguments is! ProjectModel) {
    //   // If arguments are invalid, show error and create a default project
    //   // This prevents the route from failing and redirecting to home
    //   debugPrint(
    //     'WorkDetailBinding: Invalid or missing arguments. Type: ${arguments?.runtimeType}',
    //   );
    //   Get.snackbar(
    //     'Error',
    //     'Project data is missing. Please try again.',
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   // Create a default project to prevent binding failure
      
    // } else {
    //   project = arguments;
    //   debugPrint(
    //     'WorkDetailBinding: Successfully received project: ${project.id}',
    //   );
    // }


    final db = Get.find<AppDatabase>();
    final dao = SubmissionDao(db);
    final repo = SubmissionRepository(dao);


    // Get.put<AppDatabase>(
    //   AppDatabase(),
    //   permanent: true,
    // );
    final projectDao = ProjectDao(db);
    final projectRepo = ProjectRepository(projectDao);

    Get.put(UploadProjectDetailsController(
      repo,
      ProjectDetailRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>(),
        projectRepo         
      ));

      

    /// Audio recorder controller (independent)
    Get.lazyPut(
      () => AudioRecorderController(),
    );
    
  }
}