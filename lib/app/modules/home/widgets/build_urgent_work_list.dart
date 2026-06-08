import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/build_project_card.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

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
          SizedBox(height: AppDimensions.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                text: 'Long Pending List',
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.xxs),
          Obx(() {
            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: controller.projects.length,
                itemBuilder: (context, index) {
                  final project = controller.projects[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: BuildProjectCard(
                        project.project ?? ProjectDetails(),
                        () {
                          controller.onUpdateProgressTap(
                            project.project ?? ProjectDetails(),
                            project.status ?? "",
                          );
                        },
                        true,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
