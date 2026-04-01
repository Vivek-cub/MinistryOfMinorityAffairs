import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

/// Reusable header widget for Work In Progress screen
/// Displays user avatar, title, and subtitle with gradient background
class WorkProgressHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? avatarAssetPath;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onBackPress;
  final IconData? backIcon;
  final VoidCallback? onIconPressed;
  final IconData? refreshIcon;
  final Widget? widget;

  const WorkProgressHeader({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.avatarAssetPath,
    this.onAvatarTap,
    this.onBackPress,
    this.backIcon,
    this.onIconPressed,
    this.refreshIcon,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        gradient: LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF205B5F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.fromLTRB(2, statusBarHeight + 20, 4, 20),
      child: Column(
        children: [
          Row(
            children: [
              backIcon != null
                  ? InkWell(
                    onTap: () {
                      onBackPress ?? Get.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Icon(backIcon, color: AppColors.textWhite),
                    ),
                  )
                  : SizedBox(width: 16),
              GestureDetector(
                onTap: onAvatarTap,
                child: SvgPicture.asset(
                  SvgAssets.emblemSvg,
                  width: 48,
                  height: 48,
                ),
              ),
              const SizedBox(width: AppDimensions.xs),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(text: subtitle, color: AppColors.textWhite),
                  ],
                ),
              ),
            ],
          ),
          Container(child: widget),
        ],
      ),
    );
  }
}
