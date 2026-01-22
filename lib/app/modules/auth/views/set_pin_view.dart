import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/controllers/set_pin_controller.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
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
              const Text(
                'PRADHAN MANTRI JAN VIKAS KARYAKRAM (PMJVK)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'अल्पसंख्यक कार्य मंत्रालय',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),

              const SizedBox(height: 2),

              const Text(
                'MINISTRY OF MINORITY AFFAIRS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 50),

              // Main Heading
              const Text(
                'Set Your 4-Digit PIN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'This PIN will be used for quick logins in\nthe future. Keep it confidential.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // PIN Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        // Clear the field on tap
                        controller.pinControllers[index].clear();
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Remember PIN Checkbox
              Obx(
                () => InkWell(
                  onTap: () {
                    controller.toggleRememberPin(!controller.rememberPin.value);
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
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Create PIN Button
              Obx(() {
                final isEnabled = controller.isButtonEnabled.value;
                return Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient:
                        isEnabled
                            ? const LinearGradient(
                              colors: [Color(0xFFFFA726), Color(0xFFEF5350)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            )
                            : null,
                    color: isEnabled ? null : const Color(0xFFCCCCCC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: isEnabled ? controller.createPin : null,
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
                          'Create your PIN',
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

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
