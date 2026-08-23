import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/header_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/widgets/build_stat_card.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';

class TopHeaderQuickOverview extends StatelessWidget {
  final dynamic controller;
  const TopHeaderQuickOverview({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  text: 'Quick Overview',
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap:
                        controller.isExportingAssignedProjects.value
                            ? null
                            : controller.exportAssignedProjectsExcel,
                    child: Icon(
                      Icons.download,
                      color: AppColors.textWhite,
                      size: 22,
                    ),
                    // child: CustomText(
                    //   text:
                    //       controller.isExportingAssignedProjects.value
                    //           ? "Downloading..."
                    //           : "Download",
                    // ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.textWhite,
                // color: Colors.cyan.withValues(alpha: 0.15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: BuildStatCard(
                          title: "Total Assigned",
                          backgroundColor: AppColors.governmentBlue,
                          icon: SvgAssets.assignedSvg,
                          value: controller.data.value.totalAssigned ?? 0,
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
                      ),
                      Expanded(
                        child: BuildStatCard(
                          title: 'Geotagged',
                          value: controller.data.value.geoTagged ?? 0,
                          icon: SvgAssets.geotaggedSvg,
                          iconColor: AppColors.newPrimaryLight,

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
                      ),
                      Expanded(
                        child: BuildStatCard(
                          title: 'Non-Geotagged',
                          value: controller.data.value.nonGeoTagged ?? 0,
                          icon: SvgAssets.nonGeotaggedSvg,
                          iconColor: AppColors.newSecondaryLight,
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

/*

return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xxs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: HeaderText(
              text: 'Quick Overview',
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          SizedBox(height: 12),
          Obx(() {
            return InkWell(
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.textWhite,
                  // color: Colors.cyan.withValues(alpha: 0.15),
                ),
                child: Row(
                  children: [
                    Container(
                      //height: 24,
                      height: 60,
                      width: 60,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        SvgAssets.assignedSvg ?? "",
                        colorFilter: ColorFilter.mode(
                          AppColors.governmentBlue,
                          BlendMode.srcIn,
                        ),
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Total Assigned Projects",
                          textAlign: TextAlign.center,
                          color: AppColors.textPrimary,
                          maxLines: 3,
                        ),

                        HeaderText(
                          text:
                              "(${controller.data.value.totalAssignedProposals ?? 0}) ",
                          color: AppColors.textPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
*/
