import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/splash/bindings/splash_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/splash/views/splash_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/bindings/home_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/views/home_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/mobile_number_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/otp_verification_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/set_pin_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/pin_login_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/mobile_number_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/otp_verification_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/set_pin_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/pin_login_view.dart';
import 'app_routes.dart';

/// Application pages and route configuration
/// This class defines all routes and their corresponding pages with bindings
class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.mobileNumber,
      page: () => MobileNumberView(),
      binding: MobileNumberBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => OtpVerificationView(),
      binding: OtpVerificationBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.setPin,
      page: () => SetPinView(),
      binding: SetPinBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.pinLogin,
      page: () => PinLoginView(),
      binding: PinLoginBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // Add more routes here
  ];
}
