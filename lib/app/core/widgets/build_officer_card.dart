import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/routes/app_routes.dart';
import 'package:ministry_of_minority_affairs/app/stateModules/dashboard/domain/entity/field_officer_not_visited.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class BuildOfficerCard extends StatelessWidget {
  final FieldOfficersNotVisited project;
  final VoidCallback? onPressed;

  BuildOfficerCard({required this.project, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return buildProjectCard(project, onPressed);
  }

  Widget buildProjectCard(
    FieldOfficersNotVisited project,
    VoidCallback? onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.textHint),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: TitleText(
                  text: project.name ?? "",
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          // const SizedBox(height: AppDimensions.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              project.username != null
                  ? Expanded(
                    child: CustomText(
                      text: "${project.username}",
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  : SizedBox.shrink(),
              const SizedBox(width: 8),
            ],
          ),
          // const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: CustomText(text: project.email ?? "", maxLines: 2),
                    ),
                  ],
                ),
              ),

              //  const SizedBox(width: AppDimensions.md),

              // Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     Icon(
              //       Icons.access_time,
              //       size: 16,
              //       color: AppColors.textPrimary,
              //     ),
              //     const SizedBox(width: 4),
              //     CustomText(
              //       text: Helpers.formatDateMedium(
              //         project.createdAt ?? DateTime.now(),
              //       ),
              //       maxLines: 1,
              //     ),
              //   ],
              // ),
            ],
          ),

          // isShowingCalendar == true
          //     ? const SizedBox(height: AppDimensions.md)
          //     : SizedBox.shrink(),
          // isShowingCalendar == true
          //     ? Row(
          //       children: [Expanded(child: MilestoneProgress(progress: 40))],
          //     )
          //     : SizedBox.shrink(),
          const SizedBox(height: AppDimensions.md),

          // AuthSubmitButton(
          //   title: "Update Current Status",
          //   isEnabled: true,
          //   height: 44,
          //   onPressed: onPressed,
          //   isUrgent: isUrgent ?? false,
          // ),
        ],
      ),
    );
  }
}
