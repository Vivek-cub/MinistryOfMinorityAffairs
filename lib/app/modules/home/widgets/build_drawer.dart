import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:ministry_of_minority_affairs/app/utils/lanuage_constant.dart';

class BuildDrawer extends StatelessWidget {
  HomeController controller;
  BuildDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
              decoration: BoxDecoration(gradient: OldAppGradientColor.gradient),

              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageAssets.emblemImage),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                          AppColors.textWhite,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.xxs),
                  CustomText(
                    text: LanuageConstant.appTitle,
                    color: AppColors.background,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppDimensions.s),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.xs,
                      vertical: AppDimensions.xxs,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimensions.sm),
                      color: AppColors.textWhite,
                      border: Border.all(color: AppColors.governmentGold),
                    ),
                    child: Row(
                      children: [
                        Obx(() {
                          final profilePath =
                              controller.data.value.user?.profilePath;
                          return InkWell(
                            onTap: () {
                              controller.closDrawer();
                              controller.takePhoto();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                    image: DecorationImage(
                                      image:
                                          profilePath != null &&
                                                  profilePath.isNotEmpty
                                              ? NetworkImage(profilePath)
                                              : AssetImage(IconAssets.user)
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                /// 🔹 Edit Icon
                                Positioned(
                                  bottom: -2,
                                  right: -2,
                                  child: Container(
                                    height: 26,
                                    width: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.textHint,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(width: AppDimensions.xs),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => TitleText(
                                  text: controller.userName.value,
                                  maxLines: 2,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),

                              CustomText(
                                text:
                                    controller.data.value.user?.phoneNumber ??
                                    "",
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () {
                Get.back();
                controller.onDashboardTap();
              },
            ),
            _buildDrawerItem(
              icon: Icons.task,
              title: 'Completed Project',
              onTap: () {
                Get.back();
                controller.onProjetTap();
              },
            ),
            _buildDrawerItem(
              icon: Icons.lock_outline,
              title: 'Change PIN',
              onTap: () {
                Get.back();
                controller.onChangePinTap();
              },
            ),
            _buildDrawerItem(
              icon: Icons.calendar_month,
              title: 'Calender',
              onTap: () {
                Get.back();
                controller.onCalendarTap();
              },
            ),
            const Spacer(),
            const Divider(),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                Get.back();
                controller.onLogoutTap();
              },
              textColor: AppColors.textPrimary,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Version 1.0.1',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.textPrimary,
          fontFamily: "Montserrat",
        ),
      ),
      onTap: onTap,
    );
  }
}
