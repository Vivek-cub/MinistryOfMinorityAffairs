import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_detail_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/projects/controllers/audio_recorder_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/controller/work_detail_controller.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Work Detail binding
/// Handles dependency injection for Work Detail screen
class WorkDetailBinding extends Bindings {
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


    Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );


    Get.put(WorkDetailController(
      repo,
      ProjectDetailRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>()         
      ));

      

    /// Audio recorder controller (independent)
    Get.lazyPut(
      () => AudioRecorderController(),
    );
    
  }
}
