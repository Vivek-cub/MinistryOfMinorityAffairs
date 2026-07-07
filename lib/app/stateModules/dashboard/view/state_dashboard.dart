import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_drawer.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_stat_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/top_header_quick_overview.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/services/update_service.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/controller/state_dashboard_controller.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/view/build_officer_list.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class StateDashboard extends GetView<StateDashboardController> {
  const StateDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateService.build(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
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
                                subtitle:
                                    "Assigned State - ${controller.assignedState.value}",
                                avatarAssetPath: ImageAssets.emblemImage,
                                onAvatarTap: () {
                                  controller.openDrawer();
                                },

                                refreshIcon: Icons.refresh,
                                onIconPressed: () {
                                  controller.checkInternet();
                                },
                                widget: TopHeaderQuickOverview(
                                  controller: controller,
                                ),

                                // onBackPress: () => controller.openDrawer(),
                              ),
                              _buildQuickOverview(context),
                              controller.data.value.fieldOfficersNotVisited !=
                                          null &&
                                      controller
                                          .data
                                          .value
                                          .fieldOfficersNotVisited!
                                          .isNotEmpty
                                  ? BuildOfficerList(controller: controller)
                                  : SizedBox.shrink(),
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
                            SizedBox(
                              height: AppDimensions.sideIndicator2Height,
                            ),
                            TitleText(text: "No Internet"),
                            const SizedBox(height: AppDimensions.gigantic),
                            // Container(
                            //   margin: EdgeInsets.symmetric(
                            //     horizontal: AppDimensions.gigantic,
                            //     vertical: AppDimensions.xxl,
                            //   ),
                            //   child: AuthSubmitButton(
                            //     title: "Open Project List",
                            //     isEnabled: true,
                            //     onPressed: () {
                            //       Get.offNamed(
                            //         AppRoutes.projectList,
                            //         arguments: {
                            //           'status': "noInternet",
                            //           'paramName': "noInternet",
                            //           'statusFilter': "",
                            //         },
                            //       );
                            //     },
                            //   ),
                            //),
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
      ),
    );
  }

  Widget _buildQuickOverview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final data = controller.data.value;

            return IntrinsicHeight(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: BuildStatCard(
                          title: 'Not Started',
                          value: controller.data.value.notStarted ?? 0,
                          icon: SvgAssets.notStartedSvg,
                          iconColor: AppColors.error,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "Not Started",
                                'paramName': "status",
                                'statusFilter': "not_started",
                              },
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: BuildStatCard(
                          title: 'Work in Progress',
                          value: controller.data.value.inProgress ?? 0,
                          icon: SvgAssets.workInProgressSvg,
                          iconColor: AppColors.governmentGold,

                          onTap: () {
                            Get.toNamed(
                              AppRoutes.projectList,
                              arguments: {
                                'status': "In Progress",
                                'paramName': "status",
                                'statusFilter': "in_progress",
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      // Expanded(
                      //   child: BuildStatCard(
                      //     title: 'Functional',
                      //     value: controller.data.value.geoTagged ?? 0,
                      //     icon: SvgAssets.functionalSvg,
                      //     iconColor: AppColors.info,

                      //     onTap: () {
                      //       Get.toNamed(
                      //         AppRoutes.projectList,
                      //         arguments: {
                      //           'status': "Completed",
                      //           'paramName': "status",
                      //           'statusFilter': "completed",
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      // Expanded(
                      //   child: BuildStatCard(
                      //     title: 'Not Functional',
                      //     value: controller.data.value.nonGeoTagged ?? 0,
                      //     icon: SvgAssets.notFunctionalSvg,
                      //     iconColor: AppColors.warning,
                      //     onTap: () {
                      //       Get.toNamed(
                      //         AppRoutes.projectList,
                      //         arguments: {
                      //           'status': "Completed",
                      //           'paramName': "status",
                      //           'statusFilter': "completed",
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                      Expanded(
                        child: BuildStatCard(
                          title: 'Completed',
                          value: controller.data.value.totalCompleted ?? 0,
                          icon: SvgAssets.completedSvg,
                          iconColor: AppColors.secondary,

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
                      ),

                      Expanded(
                        child: BuildStatCard(
                          title: 'Field Officer',
                          value:
                              controller
                                  .data
                                  .value
                                  .totalAssignedFieldOfficers ??
                              0,
                          icon: SvgAssets.geotaggedSvg,
                          iconColor: AppColors.governmentBlue,

                          onTap: () {
                            Get.toNamed(AppRoutes.officerList);
                          },
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
