import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';

/// Reusable header widget for Work In Progress screen
/// Displays user avatar, title, and subtitle with gradient background
class WorkProgressHeader extends StatelessWidget {
  final String? userName;
  final String title;
  final String subtitle;
  final String? avatarAssetPath;
  final VoidCallback? onAvatarTap;

  const WorkProgressHeader({
    super.key,
    this.userName,
    this.title = 'Work In Progress',
    this.subtitle = 'Track Progress of works in real-time',
    this.avatarAssetPath,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, statusBarHeight + 20, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image:
                    avatarAssetPath != null
                        ? DecorationImage(
                          image: AssetImage(avatarAssetPath!),
                          fit: BoxFit.cover,
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
