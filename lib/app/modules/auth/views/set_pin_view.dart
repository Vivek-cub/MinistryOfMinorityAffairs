import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: AppDimensions.gigantic),
            
                AuthHeader(),
            
            
                // Main Heading
                HeaderText(text: "Set Your 4-Digit PIN"),
                
            
            
                // Subtitle
                CustomText(text: "This PIN will be used for quick logins in\nthe future. Keep it confidential.",textAlign: TextAlign.center,),
                
            
                const SizedBox(height: AppDimensions.md),
            
                // PIN Input Fields
              Wrap(
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


              const SizedBox(height: AppDimensions.md),
            
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
                Obx(
                (){
                  final isEnabled = controller.isButtonEnabled.value;
                  return AuthSubmitButton(
                    title: 'Create your PIN',
                    isEnabled: isEnabled,
                    onPressed: (){
                        if (isEnabled) {
                          controller.createPin();
                        }
                      },
                    ); 
                }
              ),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
