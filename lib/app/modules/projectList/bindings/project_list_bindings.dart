

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/repo/project_list_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class ProjectListBindings extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<AppDatabase>();
    final dao = ProjectDao(db);
    final repo = ProjectRepository(dao);
    Get.lazyPut<ProjectsListController>(() => ProjectsListController(
        ProjectListRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>(),
        repo
    ));
  }
}