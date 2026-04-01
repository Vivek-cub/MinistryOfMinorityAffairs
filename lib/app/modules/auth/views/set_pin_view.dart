import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/otp_section.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/set_pin_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';

/// Set PIN View
/// Allows users to create a 4-digit PIN for quick login
class SetPinView extends StatelessWidget {
  SetPinView({super.key});
  final SetPinController controller = Get.find<SetPinController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppGradientColor.gradient),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.gigantic),
                AuthHeader(),
                HeaderText(
                  text: "Set Your 4-Digit PIN",
                  color: AppColors.textWhite,
                ),
                CustomText(
                  text:
                      "This PIN will be used for quick logins in\nthe future. Keep it confidential.",
                  textAlign: TextAlign.center,
                  color: AppColors.textWhite,
                ),
                const SizedBox(height: AppDimensions.md),
                OtpSection(
                  length: 4,
                  boxWidth: 55,
                  boxHeight: 60,
                  borderRadius: 12,
                  onCompleted: (otp) {
                    controller.otp(otp);
                    // controller.createPin(otp);
                  },
                ),

                const SizedBox(height: AppDimensions.lg),

                Obx(
                  () => InkWell(
                    onTap: () {
                      controller.toggleRememberPin(
                        !controller.rememberPin.value,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                controller.rememberPin.value
                                    ? const Color(0xFFFFA726)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color:
                                  controller.rememberPin.value
                                      ? const Color(0xFFFFA726)
                                      : const Color(0xFFE0E0E0),
                              width: 2,
                            ),
                          ),
                          child:
                              controller.rememberPin.value
                                  ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Let\'s make sure you remember your PIN.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Create PIN Button
                AuthSubmitButton(
                  title: 'Create your PIN',
                  isEnabled: true,
                  isAuthButton: true,
                  onPressed: () {
                    controller.createPin(controller.otp.value);
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
