import 'package:blinking_border/blinking_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_drawer.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_stat_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_urgent_work_list.dart';
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
          child: Stack(
            children: [
              Obx(() {
                return controller.hasInternet.value == true
                    ? RefreshIndicator(
                      onRefresh: controller.checkInternet,
                      color: AppColors.primary,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                            (controller
                                            .data
                                            .value
                                            .projectsNotVisitedFor3Months ??
                                        0) >
                                    0
                                ? BuildUrgentWorkList(controller: controller)
                                : SizedBox.shrink(),
                            BuildWorkList(controller: controller),
                            const SizedBox(height: AppDimensions.sm),
                          ],
                        ),
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
              Obx(
                () =>
                    controller.isSyncing.value
                        ? Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.08),
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
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
              child: Column(
                children: [
                  /*
                  (data.totalAssignedProposals ?? 0) > 0
                      ? Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "Proposal",
                                'paramName': "status",
                                'statusFilter': "all",
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              // color: Colors.cyan.withValues(alpha: 0.15),
                            ),
                            child: BlinkingBorder(
                              blinkStyle: BlinkStyle.pulsing,
                              strokeStyle: StrokeStyle.solid,
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.error,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //height: 24,
                                    decoration: BoxDecoration(
                                      // color: backgroundColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      SvgAssets.assignedSvg ?? "",
                                      color: AppColors.textWhite,
                                      height: 40,
                                    ),
                                  ),
                                  //const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: "Assigned Proposals",
                                        textAlign: TextAlign.center,
                                        color: AppColors.textWhite,
                                        maxLines: 3,
                                      ),
                                      CustomText(
                                        text:
                                            "(${data.totalAssignedProposals ?? 0}) ",
                                        color: AppColors.textWhite,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      : SizedBox.shrink(),

*/
                  Row(
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
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
