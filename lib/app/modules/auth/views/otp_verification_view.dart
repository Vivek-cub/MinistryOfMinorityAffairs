import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_box.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/controllers/otp_verification_controller.dart';

import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';

/// OTP Verification Screen
/// Allows users to enter OTP for phone number verification
class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppButtonGradientColor.gradient),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xl),
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.xxxl),
                    AuthHeader(),
                    // Main Heading
                    HeaderText(
                      text: "Please Enter OTP\nTo Continue",
                      textAlign: TextAlign.center,
                      color: AppColors.textWhite,
                    ),

                    const SizedBox(height: AppDimensions.s),

                    // Phone Number Display
                    Obx(
                      () => RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                          children: [
                            TextSpan(text: "We've sent a 4-digit OTP to "),
                            TextSpan(
                              text: controller.phoneNumber.value,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textWhite.withValues(
                                  alpha: 0.72,
                                ),
                                fontFamily: "Montserrat",
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '.\nPlease enter it below to verify your number.',
                              style: TextStyle(fontFamily: "Montserrat"),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxl),

                    // OTP Input Fields
                    OtpSection(
                      otpKey: controller.otpKey,
                      length: 4,
                      boxWidth: 62,
                      boxHeight: 58,
                      borderRadius: 16,
                      onCompleted: (otp) {
                        controller.otp(otp);
                        controller.verifyOTP(otp);
                      },
                    ),

                    const SizedBox(height: AppDimensions.xxl),

                    // Enter OTP Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AuthSubmitButton(
                        title: "Verify",
                        isEnabled: true,
                        isAuthButton: true,
                        onPressed: () {
                          // if (isEnabled) {
                          controller.verifyOTP(controller.otp.value);
                          // }
                        },
                      ),
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
