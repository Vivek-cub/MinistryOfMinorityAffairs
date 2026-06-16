import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_urgent_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';

class BuildUrgentWorkList extends StatelessWidget {
  HomeController controller;
  BuildUrgentWorkList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.xs,
        vertical: AppDimensions.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
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
          const SizedBox(height: AppDimensions.sm1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                text: 'Long Pending List',
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              TextButton(
                onPressed: controller.onViewAllTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const CustomText(
                  text: "View More",
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          Obx(() {
            final projects = controller.pendingProjects.take(3).toList();
            return projects.isNotEmpty
                ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        projects.map((project) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                              bottom: 12,
                              top: 12,
                            ),
                            child: SizedBox(
                              width:
                                  controller.pendingProjects.length > 1
                                      ? MediaQuery.of(context).size.width * 0.80
                                      : MediaQuery.of(context).size.width *
                                          0.89,
                              child: BuildUrgentProjectCard(
                                project: project,
                                onPressed: () {
                                  controller.onUpdateProgressTap(
                                    project.unitDetails ?? UnitDetails(),
                                    project.unitDetails?.status ?? "",
                                    project.id ?? "",
                                    project,
                                    true,
                                  );
                                },
                                isUrgent: true,
                                isShowingCalendar: false,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                )
                : SizedBox(height: AppDimensions.sm);
          }),
        ],
      ),
    );
  }
}
