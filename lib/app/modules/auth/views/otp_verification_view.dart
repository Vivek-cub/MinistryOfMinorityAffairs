import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                    const SizedBox(height: AppDimensions.gigantic),
                AuthHeader(),
                // Main Heading
                HeaderText(text: LanuageConstant.enterOtp),
                HeaderText(text: "to Continue"),

                    
                const SizedBox(height: AppDimensions.sm),
                    
                // Phone Number Display
                Obx(() => RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: "We've sent a 4-digit OTP to "),
                      TextSpan(
                        text: controller.phoneNumber.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: "Montserrat"
                        ),
                      ),
                      const TextSpan(
                        text: '.\nPlease enter it below to verify your number.',
                        style: TextStyle(
                          fontFamily: "Montserrat"
                        )
                        ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                )),
                    
                const SizedBox(height: AppDimensions.xxl),
                    
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildOtpBox(index),
                    );
                  }),
                ),
                    
                const SizedBox(height: AppDimensions.xxl),
                    
                // Enter OTP Button
                    
                Obx(
                  (){
                    final isEnabled = controller.isButtonEnabled.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AuthSubmitButton(
                        title: "Verify",
                        isEnabled: isEnabled,
                        onPressed: (){
                            if (isEnabled) {
                              controller.verifyOTP();
                            }
                          },
                        ),
                    ); 
                  }
                ),
                const SizedBox(height: AppDimensions.xxl),
                    
                // Resend OTP
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Text(
                //       "Didn't receive OTP? ",
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: AppColors.textSecondary,
                //         fontFamily: "Montserrat"
                //       ),
                //     ),
                //     TextButton(
                //       onPressed: controller.resendOTP,
                //       style: TextButton.styleFrom(
                //         padding: EdgeInsets.zero,
                //         minimumSize: Size.zero,
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       ),
                //       child: const Text(
                //         'Resend OTP',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w600,
                //           color: Color(0xFF2196F3),
                //           fontFamily: "Montserrat"
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                    
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build individual OTP box
  Widget _buildOtpBox(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        onChanged: (value) {
          controller.onOtpChanged(value, index);
        },
        onTap: () {
          // Clear field when tapped
          controller.otpControllers[index].clear();
        },
      ),
    );
  }
}
