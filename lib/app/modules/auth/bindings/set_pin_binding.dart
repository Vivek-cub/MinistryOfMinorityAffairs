import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/set_pin_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/data/repo/create_pin_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

/// Set PIN Binding
/// Initializes the Set PIN controller
class SetPinBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetPinController>(
      () => SetPinController(
        Get.find<AuthService>(),
        CreatePinRepoImpl(Get.find<ApiService>()),
      ),
    );
  }
}
