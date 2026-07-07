import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';

import 'package:ministry_of_minority_affairs/app/modules/auth/login/controllers/mobile_number_controller.dart';

import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/login/data/repo/send_mobile_otp_repo_impl.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';

/// Mobile Number Entry Screen
/// Allows users to enter their mobile number for authentication
class MobileNumberView extends GetView<MobileNumberController> {
  const MobileNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppDimensions.xxxl),
                    AuthHeader(),
                    // Main Heading
                    HeaderText(
                      text: LanuageConstant.enterPhoneText,
                      color: AppColors.textWhite,
                    ),

                    const SizedBox(height: 6),
                    CustomText(
                      text:
                          "We'll send a verification code to your mobile number",
                      color: AppColors.textWhite.withValues(alpha: 0.82),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.md),

                    // Phone Number Input
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Country Code
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: const Text(
                              '+91',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1,
                            height: 30,
                            color: AppColors.divider,
                          ),

                          // Phone Number Field
                          Expanded(
                            child: TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,

                              decoration: const InputDecoration(
                                hintText: 'Mobile Number',
                                hintStyle: TextStyle(
                                  color: Color(0xFFCCCCCC),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              style: TextStyle(fontFamily: "Montserrat"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimensions.xxxl),

                    // Next Button
                    Obx(() {
                      final isEnabled = controller.isButtonEnabled.value;
                      return AuthSubmitButton(
                        title: "Next",
                        isEnabled: isEnabled,
                        isAuthButton: true,
                        onPressed: () {
                          if (isEnabled) {
                            controller.sendOTP(
                              controller.phoneController.text.trim(),
                            );
                          }
                        },
                      );
                    }),
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
