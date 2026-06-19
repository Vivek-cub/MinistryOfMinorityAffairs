import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/calender/bindings/calendar_project_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/calender/views/calendar_project.dart';
import 'package:ministry_of_minority_affairs/app/modules/pin/bindings/check_old_pin_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/pin/views/check_old_pin.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/binding/upload_project_details_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/upload_project_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/bindings/image_list_bindings.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/bindings/project_list_bindings.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/views/image_list_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/views/project_list_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/binding/update_proposal_latlng_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/proposals/view/update_proposal_latlng_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/splash/bindings/splash_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/splash/views/splash_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/bindings/home_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/views/home_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/bindings/mobile_number_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/bindings/otp_verification_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/set_pin_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/bindings/pin_login_binding.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/mobile_number_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/otp_verification_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/set_pin_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/pin_login_view.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/binding/work_detail_binding.dart';

import 'package:ministry_of_minority_affairs/app/modules/projectDetails/views/work_detail_view.dart';
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
      name: AppRoutes.oldPinCheck,
      page: () => CheckOldPin(),
      binding: CheckOldPinBinding(),
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

    // Projects routes
    GetPage(
      name: AppRoutes.workDetail,
      page: () => WorkDetailView(),
      binding: WorkDetailBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.projectList,
      page: () => ProjectListView(),
      binding: ProjectListBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.uploadProjectDetails,
      page: () => UploadProjectDetails(),
      binding: UploadProjectDetailsBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.calendarProject,
      page: () => CalendarProject(),
      binding: CalendarProjectBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.updateProposalLatlng,
      page: () => UpdateProposalLatlngView(),
      binding: UpdateProposalLatlngBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.seeImageList,
      page: () => ImageListView(),
      binding: ImageListBindings(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    // Add more routes here
  ];
}
