import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/controller/officer_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/officerLIst/data/repo/officer_list_repo_impl.dart';

class OfficerListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfficerListController>(
      () => OfficerListController(
        OfficerListRepoImpl(Get.find<ApiService>()),
        Get.find<AuthService>(),
      ),
    );
  }
}
