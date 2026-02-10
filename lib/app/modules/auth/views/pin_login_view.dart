import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/pin_login_controller.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child:  Column(
              children: [
                const SizedBox(height: 40),

                // Government Logo
                Image.asset(
                  'assets/images/emblem.png',
                  color: AppColors.governmentBlue,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_balance,
                      size: 80,
                      color: AppColors.governmentBlue,
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Title
                CustomText(
                  text: LanuageConstant.appTitle,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  ),

                
                const SizedBox(height: 4),

                const Text(
                  LanuageConstant.appTitleHindi,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10, color: AppColors.textSecondary,
                    fontFamily: "Montserrat"
                    ),
                ),

                const SizedBox(height: 2),
                CustomText(
                  text: LanuageConstant.moma,
                  textAlign: TextAlign.center,

                  ),
               

                const SizedBox(height: AppDimensions.gigantic),

                // Main Heading
                HeaderText(
                  text: LanuageConstant.enterPinText,
                  ),
                

                const SizedBox(height: AppDimensions.xs),

                // Subtitle
                CustomText(
                  text: 'Use your 4-digit PIN to login',
                  ),
                

                const SizedBox(height: 40),

                // PIN Input Fields

                Wrap  (
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    4,
                        (index) => SizedBox(
                      width: MediaQuery.of(context).size.width*0.20,
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

                const SizedBox(height: 24),

                // Forgot PIN Link
                TextButton(
                  onPressed: controller.forgotPin,
                  child: const Text(
                    'Forgot PIN?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Login Button
                Obx(() {
                  final isEnabled = controller.isButtonEnabled.value;
                  return Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: isEnabled
                          ? const LinearGradient(
                        colors: [
                          Color(0xFFFFA726),
                          Color(0xFFEF5350),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                          : null,
                      color: isEnabled ? null : const Color(0xFFCCCCCC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: isEnabled ? controller.login : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
                    ),
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
