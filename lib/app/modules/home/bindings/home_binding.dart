import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/data/repo/home_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/domain/repo/home_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_detail_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/domain/repo/project_detail_repo.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/repo/project_list_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/network_service.dart';
import '../controllers/home_controller.dart';

/// Home screen binding
/// Initializes dependencies for home screen
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepo>(() => HomeRepoImpl(Get.find<ApiService>()));

    Get.lazyPut<ProjectDetailRepo>(
      () => ProjectDetailRepoImpl(Get.find<ApiService>()),
    );
    final db = Get.find<AppDatabase>();
    final dao = SubmissionDao(db);
    final repo = SubmissionRepository(dao);

    Get.lazyPut<HomeController>(
      () => HomeController(
        HomeRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>(),
        repo,
        ProjectDetailRepoImpl(Get.find<ApiService>()),
        ProjectListRepoImpl(Get.find<ApiService>()),
        //  Get.find<ProjectDao>(),
      ),
    );
  }
}
