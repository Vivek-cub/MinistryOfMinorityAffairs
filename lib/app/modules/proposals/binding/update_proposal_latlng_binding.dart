import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/controller/update_proposal_latlng_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/data/repo/update_proposal_latlng_impl.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';

class UpdateProposalLatlngBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProposalLatlngController>(
      () => UpdateProposalLatlngController(
        UpdateProposalLatlngImpl(Get.find<ApiService>()),
        Get.find<AuthService>(),
      ),
    );
  }
}
