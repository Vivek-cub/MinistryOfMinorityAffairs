import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/pin_login_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';

/// PIN Login View
/// Allows users to login using their 4-digit PIN
class PinLoginView extends StatelessWidget {
  PinLoginView({super.key});
  final PinLoginController controller = Get.find<PinLoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppGradientColor.gradient),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 36.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.gigantic),
                AuthHeader(),
                HeaderText(
                  text: LanuageConstant.enterPinText,
                  color: AppColors.textWhite,
                ),
                CustomText(
                  text: 'Use your 4-digit PIN to login',
                  color: AppColors.textWhite,
                ),
                const SizedBox(height: AppDimensions.md),
                OtpSection(
                  length: 4,
                  boxWidth: 55,
                  boxHeight: 60,
                  borderRadius: 12,
                  onCompleted: (otp) {
                    controller.pin(otp);
                    controller.login(otp);
                  },
                ),

                const SizedBox(height: AppDimensions.lg),
                AuthSubmitButton(
                  title: "Login",
                  isEnabled: true,
                  isAuthButton: true,
                  onPressed: () {
                    controller.login(controller.pin.value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
