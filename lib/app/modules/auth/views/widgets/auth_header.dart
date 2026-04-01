import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        SizedBox(
          height: 110,
          width: 66,
          child: SvgPicture.asset(SvgAssets.emblemSvg),
        ),

        const SizedBox(height: AppDimensions.md),

        // Title
        TitleText(
          text: 'PRADHAN MANTRI JAN VIKAS KARYAKRAM (PMJVK)',
          textAlign: TextAlign.center,
          color: AppColors.textWhite,
          maxLines: 3,
          fontWeight: FontWeight.w600,
        ),

        const SizedBox(height: AppDimensions.xxs),

        CustomText(
          text: 'अल्पसंख्यक कार्य मंत्रालय',
          textAlign: TextAlign.center,
          color: AppColors.textWhite,
        ),

        const SizedBox(height: AppDimensions.xxs),

        const Text(
          'MINISTRY OF MINORITY AFFAIRS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textWhite,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: AppDimensions.xxxl),
      ],
    );
  }
}
