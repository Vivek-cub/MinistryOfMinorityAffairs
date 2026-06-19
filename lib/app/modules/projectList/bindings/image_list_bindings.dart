import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/image_list_controller.dart';

class ImageListBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageListController>(() => ImageListController());
  }
}
