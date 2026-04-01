import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';
import '../controllers/splash_controller.dart';

/// Splash screen view
/// Displays the Ministry of Minority Affairs splash screen
class SplashView extends StatelessWidget {
  SplashView({super.key});
  final SplashController controller = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.indiaGateImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120,
              width: 120,
              child: SvgPicture.asset(SvgAssets.emblemSvg),
            ),
            const SizedBox(height: AppDimensions.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              child: TitleText(
                text: LanuageConstant.appTitle,
                color: AppColors.textWhite,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              child: TitleText(
                text: LanuageConstant.appTitleHindi,
                color: AppColors.textWhite,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
              child: TitleText(
                text: LanuageConstant.moma,
                color: AppColors.textWhite,
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
