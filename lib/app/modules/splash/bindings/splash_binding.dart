import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

/// Splash screen binding
/// Initializes dependencies for splash screen
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
