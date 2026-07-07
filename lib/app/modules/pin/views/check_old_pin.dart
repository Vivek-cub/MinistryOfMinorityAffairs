import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/pin/controller/check_old_pin_controller.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';

class CheckOldPin extends GetView<CheckOldPinController> {
  const CheckOldPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: AppButtonGradientColor.gradient),
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.gigantic),
                AuthHeader(),
                // Main Heading
                HeaderText(
                  text: "Enter Current Pin",
                  textAlign: TextAlign.center,
                  color: AppColors.background,
                ),
                // Subtitle
                CustomText(
                  text: 'Use your current 4-digit PIN',
                  color: AppColors.background,
                ),
                const SizedBox(height: AppDimensions.md),
                // PIN Input Fields
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    4,
                    (index) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: 70,
                      child: TextField(
                        controller: controller.pinControllers[index],
                        focusNode: controller.focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        onChanged: (value) {
                          controller.onPinChanged(value, index);
                        },
                        onTap: () {
                          controller.pinControllers[index].clear();
                        },
                      ),
                    ),
                  ),
                ),

                // Login Button
                Obx(() {
                  final isEnabled = controller.isButtonEnabled.value;
                  return AuthSubmitButton(
                    title: "Next",
                    isEnabled: true,
                    isAuthButton: true,

                    onPressed: () {
                      if (isEnabled) {
                        controller.login();
                      }
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
