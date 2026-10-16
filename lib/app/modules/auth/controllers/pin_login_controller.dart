import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/popup_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/mixin/snackbar_mixin.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/domain/repo/create_pin_repo.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_notification_service.dart';

class PinLoginController extends GetxController with PopupMixin, SnackBarMixin {
  final AuthService authService;
  final CreatePinRepo createPinRepo;
  PinLoginController(this.authService, this.createPinRepo);
  RxString pin = "".obs;
  RxBool isVerifying = false.obs;
  RxString otp = "".obs;
  RxString phoneNumber = "".obs;
  final GlobalKey<MaskedOtpInternalState> otpKey =
      GlobalKey<MaskedOtpInternalState>();

  // void login(String pinNo) async {
  //   if (pinNo.length != 4) {
  //     showErrorDialog(Get.context!, message: "Please enter a 4-digit PIN");
  //     return;
  //   }
  //   final isMatched = await authService.isPinMatched(pinNo);
  //   // Verify PIN with stored PIN
  //   if (isMatched == true) {
  //     authService.markPinVerifiedForSession();
  //     Get.back();
  //     WidgetsBinding.instance.addPostFrameCallback((_) async {
  //       Get.offNamed(await authService.dashboardRoute());
  //     });
  //   } else {
  //     pin.value = "";

  //     otpKey.currentState?.clear();
  //     showErrorDialog(
  //       Get.context!,
  //       message: "The PIN you entered is incorrect. Please try again.",
  //     );
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments['phoneNumber'] ?? '';
  }

  void login(String pinNo) async {
    if (pinNo.length != 4) {
      showErrorDialog(Get.context!, message: "Please enter a 4-digit PIN");
      return;
    }
    final fcmToken = Get.find<FirebaseNotificationService>().fcmToken ?? "";

    debugPrint("Fcm Token: $fcmToken");

    try {
      if (isVerifying.value) return;

      isVerifying.value = true;
      showAlertCustom(backBtnDisable: true, title: "Login...");
      final modelData = await createPinRepo.verifyPin(
        mobileNo: phoneNumber.value,
        pin: pinNo,
        fcmToken: fcmToken,
      );

      if (modelData?.statusCode == '200') {
        Get.back();
        await authService.onLogin(modelData?.data?.token ?? '');
        final role =
            modelData?.data?.user?.role?.name ??
            modelData?.data?.user?.role?.label ??
            '';
        if (role.isNotEmpty) {
          await authService.setUserRole(role);
        }
        //final hasPin = await authService.checkPinFromStorage();

        Get.offNamed(AppRoutes.home);
      } else {
        otp.value = "";
        otpKey.currentState?.clear();
        Get.back();
      }
    } catch (e) {
      otp.value = "";
      otpKey.currentState?.clear();
      Get.back();
      //debugPrint(e.toString());
    } finally {
      isVerifying.value = false;
    }
  }
}

/// Handle forgot PIN
void forgotPin() {
  Get.dialog(
    AlertDialog(
      title: const Text('Forgot PIN?'),
      content: const Text(
        'To reset your PIN, you need to verify your mobile number again.',
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            Get.back();
            Get.offAllNamed(AppRoutes.mobileNumber);
          },
          child: const Text('Reset PIN'),
        ),
      ],
    ),
  );
}
