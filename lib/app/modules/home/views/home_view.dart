import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_drawer.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_stat_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_work_list.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import '../controllers/home_controller.dart';

/// Home screen view
/// Main landing screen of the application
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.background,
        drawer: BuildDrawer(controller: controller),
        body: SafeArea(
          top: false,
          bottom: true,
          child: Obx(() {
            return controller.hasInternet.value == true
                ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //_buildHeader(context),
                      WorkProgressHeader(
                        title: "Welcome ${controller.userName.value}",
                        subtitle: "Track Progress of works in real-time",
                        avatarAssetPath: ImageAssets.emblemImage,
                        onAvatarTap: () {
                          controller.openDrawer();
                        },

                        refreshIcon: Icons.refresh,
                        onIconPressed: () {
                          controller.checkInternet();
                        },
                        // onBackPress: () => controller.openDrawer(),
                        widget: _buildQuickOverview(context),
                      ),

                      BuildWorkList(controller: controller),
                      const SizedBox(height: AppDimensions.sm),
                    ],
                  ),
                )
                : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      WorkProgressHeader(
                        title: "Welcome Back",
                        subtitle: "Track Progress of works in real-time",
                        avatarAssetPath: ImageAssets.emblemImage,
                        onAvatarTap: () {
                          // controller.openDrawer();
                        },
                        refreshIcon: Icons.refresh,
                        onIconPressed: () {
                          controller.checkInternet();
                        },
                      ),
                      SizedBox(height: AppDimensions.sideIndicator2Height),
                      TitleText(text: "No Intenet"),
                      const SizedBox(height: AppDimensions.gigantic),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: AppDimensions.gigantic,
                          vertical: AppDimensions.xxl,
                        ),
                        child: AuthSubmitButton(
                          title: "Open Project List",
                          isEnabled: true,
                          onPressed: () {
                            Get.offNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "noInternet",
                                'paramName': "noInternet",
                                'statusFilter': "",
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
          }),
        ),
      ),
    );
  }

  Widget _buildQuickOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          TitleText(
            text: 'Quick Overview',
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
          ),

          const SizedBox(height: 16),
          Obx(() {
            final data = controller.data.value;

            return IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        BuildStatCard(
                          title: 'Assigned Projects',
                          value: data.totalAssigned ?? 0,
                          icon: SvgAssets.assignedSvg,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "All",
                                'paramName': "status",
                                'statusFilter': "all",
                              },
                            );
                          },
                        ),
                        IntrinsicHeight(
                          child: Container(
                            height: 1,
                            color: AppColors.textWhite,
                          ),
                        ),
                        BuildStatCard(
                          title: 'Completed',
                          value: controller.data.value.totalCompleted ?? 0,
                          icon: SvgAssets.completedSvg,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "Completed",
                                'paramName': "status",
                                'statusFilter': "completed",
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppDimensions.xxsm),
                  VerticalDivider(color: AppColors.textWhite, width: 1),
                  const SizedBox(width: AppDimensions.xxsm),

                  Expanded(
                    child: Column(
                      children: [
                        BuildStatCard(
                          title: 'Not Started',
                          value: controller.data.value.notStarted ?? 0,
                          icon: SvgAssets.notStartedSvg,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "NotStarted",
                                'paramName': "status",
                                'statusFilter': "not_started",
                              },
                            );
                          },
                        ),
                        IntrinsicHeight(
                          child: Container(
                            height: 1,
                            color: AppColors.textWhite,
                          ),
                        ),
                        BuildStatCard(
                          title: 'Geotagged',
                          value: controller.data.value.geoTagged ?? 0,
                          icon: SvgAssets.geotaggedSvg,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "",
                                'paramName': "geoTagged",
                                'statusFilter': "",
                                'geoStatus': true,
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppDimensions.xxsm),
                  VerticalDivider(color: AppColors.textWhite, width: 1),
                  const SizedBox(width: AppDimensions.xxsm),

                  Expanded(
                    child: Column(
                      children: [
                        BuildStatCard(
                          title: 'Work in Progress',
                          value: controller.data.value.inProgress ?? 0,
                          icon: SvgAssets.notStartedSvg,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "Assigned",
                                'paramName': "status",
                                'statusFilter': "in_progress",
                              },
                            );
                          },
                        ),
                        IntrinsicHeight(
                          child: Container(
                            height: 1,
                            color: AppColors.textWhite,
                          ),
                        ),
                        BuildStatCard(
                          title: 'Non-Geotagged',
                          value: controller.data.value.nonGeoTagged ?? 0,
                          icon: SvgAssets.nonGeotaggedSvg,
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "",
                                'paramName': "geoTagged",
                                'statusFilter': "",
                                'geoStatus': false,
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
