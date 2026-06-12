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
          decoration: BoxDecoration(
            gradient: OldAppButtonGradientColor.gradient,
          ),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimensions.xxxl),
                    AuthHeader(),
                    HeaderText(
                      text: "Welcome Back",
                      color: AppColors.textWhite,
                    ),
                    const SizedBox(height: 6),
                    CustomText(
                      text: "Secure login for project monitoring",
                      color: AppColors.textWhite.withValues(alpha: 0.85),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.s),
                    CustomText(
                      text: 'Use your 4-digit PIN to login',
                      color: AppColors.textWhite,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                    OtpSection(
                      length: 4,
                      boxWidth: 62,
                      boxHeight: 58,
                      borderRadius: 16,
                      onCompleted: (otp) {
                        controller.pin(otp);
                        controller.login(otp);
                      },
                    ),
                    const SizedBox(height: AppDimensions.xxl),
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
        ),
      ),
    );
  }
}
