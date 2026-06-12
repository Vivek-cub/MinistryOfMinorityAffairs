import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';

class BuildWorkList extends StatelessWidget {
  HomeController controller;
  BuildWorkList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.xs,
        vertical: AppDimensions.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
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
              TitleText(text: 'Work List', fontWeight: FontWeight.bold),

              TextButton(
                onPressed: controller.onViewAllTap,

                child: const CustomText(
                  text: "View More",
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          Obx(() {
            final projects = controller.projects.take(3).toList();
            return Column(
              children:
                  projects.map((project) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BuildProjectCard(
                        project: project.unitDetails ?? UnitDetails(),
                        onPressed: () {
                          controller.onUpdateProgressTap(
                            project.unitDetails ?? UnitDetails(),
                            project.status ?? "",
                            "",
                          );
                        },
                        isUrgent: false,
                        isShowingCalendar: false,
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
