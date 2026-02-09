
import 'package:get/get.dart';
import '../database/app_database.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );
  }
}
