import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
    // final MobileNumberController controller = Get.put(
    //   MobileNumberController(
    //     SendMobileOtpRepoImpl(Get.find<ApiService>()),
    //     Get.find<AuthService>()
    //   )
    // );
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppDimensions.sideIndicator2Height),
                AuthHeader(),
                // Main Heading
                HeaderText(
                  text: LanuageConstant.enterPhoneText
                  ),
                

                const SizedBox(height: AppDimensions.md),
                    
                // Phone Number Input
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                            fontFamily: "Montserrat"
                          ),
                        ),
                      ),
                    
                      // Divider
                      Container(width: 1, height: 30, color: AppColors.divider),
                    
                      // Phone Number Field
                      Expanded(
                        child: TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: const InputDecoration(
                            hintText: 'Please Enter your Mobile Number',
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
                              vertical: 8,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: TextStyle(
                            fontFamily: "Montserrat"
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                    
                const SizedBox(height: AppDimensions.gigantic),
                    
                // Next Button
                Obx(
                (){
                  final isEnabled = controller.isButtonEnabled.value;
                  return AuthSubmitButton(
                    title: "Next",
                    isEnabled: isEnabled,
                    onPressed: (){
                        if (isEnabled) {
                          controller.sendOTP(controller.phoneController.text.trim());
                        }
                      },
                    ); 
                }
              ),
              /*
                Obx(() {
                  final isEnabled = controller.isButtonEnabled.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (){
                        
                        if(isEnabled){
                          controller.sendOTP(controller.phoneController.text.trim());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isEnabled
                            ? AppColors.primary
                            : const Color(0xFFCCCCCC),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFCCCCCC),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Next',
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
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
