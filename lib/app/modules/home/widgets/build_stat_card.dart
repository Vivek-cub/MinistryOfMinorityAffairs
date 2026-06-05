import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class BuildStatCard extends StatelessWidget {
  final String? title;
  final int? value;
  final String? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  BuildStatCard({
    this.title,
    this.value,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: cardContainer(),
      ),
    );
  }

  Widget cardContainer() {
    return Container(padding: EdgeInsets.all(16), child: cardContent());
  }

  Widget cardContent() {
    return Column(
      children: [
        Container(
          height: 24,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(icon ?? "", color: AppColors.textWhite),
        ),
        //const SizedBox(height: 12),
        CustomText(
          text: title ?? "",
          textAlign: TextAlign.center,
          color: AppColors.textWhite,
          maxLines: 3,
        ),
        CustomText(text: "($value) ", color: AppColors.textWhite),
      ],
    );
  }
}

class BuildModernStatCard extends StatelessWidget {
  final String title;
  final int value;
  final String icon;
  final VoidCallback onTap;

  const BuildModernStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 28, color: Colors.white),

            const SizedBox(height: 12),

            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
