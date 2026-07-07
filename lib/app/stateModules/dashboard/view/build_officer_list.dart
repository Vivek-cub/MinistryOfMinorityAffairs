import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_officer_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/long_pending_officer_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_project.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/controller/state_dashboard_controller.dart';

class BuildOfficerList extends StatelessWidget {
  StateDashboardController controller;
  BuildOfficerList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.xs,
        vertical: AppDimensions.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(AppDimensions.xs),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                text: 'Not Working Officer',
                fontWeight: FontWeight.bold,
              ),

              // TextButton(
              //   onPressed: () {
              //     // Get.toNamed(
              //     //   AppRoutes.projectList,
              //     //   arguments: {
              //     //     'status': "All",
              //     //     'paramName': "status",
              //     //     'statusFilter': "all",
              //     //   },
              //     // );
              //   },

              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 12),
              //     child: const CustomText(
              //       text: "View More",
              //       color: AppColors.textPrimary,
              //     ),
              //   ),
              // ),
            ],
          ),

          SizedBox(height: AppDimensions.md),

          Obx(() {
            final projects = controller.fieldOfficerNotVisited.take(3).toList();
            return Column(
              children:
                  projects.map((project) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: LongPendingOfficerCard(
                        project: project,
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.projectList,
                            arguments: {
                              "paramName": "officer",
                              "userId": project.id,
                              "officerName": project.name,
                            },
                          );
                        },
                      ),
                      //child: _buildProjectCard(project.project??ProjectDetails()),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
