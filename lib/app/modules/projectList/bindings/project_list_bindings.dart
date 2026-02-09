

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/project_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/repo/project_list_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class ProjectListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectsListController>(() => ProjectsListController(
        ProjectListRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>()
    ));
  }
}