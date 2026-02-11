import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';

/// Reusable header widget for Work In Progress screen
/// Displays user avatar, title, and subtitle with gradient background
class WorkProgressHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? avatarAssetPath;
  final VoidCallback? onAvatarTap;

  const WorkProgressHeader({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.avatarAssetPath,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFB84D),
                    Color(0xFFFF6B6B),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        
      ),
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 20, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
               
                image:
                    avatarAssetPath != null
                        ? DecorationImage(
                          image: AssetImage(avatarAssetPath!),
                          fit: BoxFit.fill,
                        )
                        : null,
                color:
                    avatarAssetPath == null
                        ? Colors.white.withOpacity(0.3)
                        : null,
              ),
              child:
                  avatarAssetPath == null
                      ? const Icon(Icons.person, color: Colors.white, size: 28)
                      : null,
            ),
          ),
          const SizedBox(width: AppDimensions.xs),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text: title,color: AppColors.textWhite,fontWeight: FontWeight.bold,),
                CustomText(
                  text: subtitle,color: AppColors.textWhite,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
