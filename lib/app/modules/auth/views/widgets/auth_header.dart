import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
                // Government Logo
                Image.asset(
                  ImageAssets.emblemImage,
                  color: AppColors.governmentBlue,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_balance,
                      size: 100,
                      color: AppColors.governmentBlue,
                    );
                  },
                ),
                    
                const SizedBox(height: AppDimensions.md),
                    
                // Title
                TitleText(
                    text: 'PRADHAN MANTRI JAN VIKAS KARYAKRAM (PMJVK)',
                  textAlign: TextAlign.center,
                  color: AppColors.textPrimary,
                  maxLines: 3,
                  fontWeight: FontWeight.w600,
                ),

                    
                const SizedBox(height: AppDimensions.xxs),

                CustomText(
                    text: 'अल्पसंख्यक कार्य मंत्रालय',
                    textAlign: TextAlign.center,
                    color: AppColors.textPrimary,
                ),

                    
                const SizedBox(height: AppDimensions.xxs),
                    
                const Text(
                  'MINISTRY OF MINORITY AFFAIRS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                    
                const SizedBox(height: AppDimensions.xxxl),
      ],
    );
  }
}