import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class BuildUrgentProjectCard extends StatelessWidget {
  final UserProject project;
  final VoidCallback? onPressed;
  bool? isUrgent = false;
  bool? isShowingCalendar = false;
  BuildUrgentProjectCard({
    required this.project,
    required this.onPressed,
    required this.isUrgent,
    required this.isShowingCalendar,
  });
  @override
  Widget build(BuildContext context) {
    return buildProjectCard(project, onPressed);
  }

  Widget buildProjectCard(UserProject project, VoidCallback? onPressed) {
    debugPrint("isShowingCalendar  ${isShowingCalendar.toString()}");
    Color statusColor;
    Color statusBgColor;

    switch (project.status) {
      case 'ACTIVE':
        statusColor = Colors.blue;
        statusBgColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case 'Pending':
        statusColor = Colors.amber;
        statusBgColor = Colors.amber.withValues(alpha: 0.1);
        break;

      case 'In Progress':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case 'Assigned':
        statusColor = Colors.red;
        statusBgColor = Colors.red.withValues(alpha: 0.1);
        break;
      case 'Completed':
        statusColor = Colors.green;
        statusBgColor = Colors.green.withValues(alpha: 0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isUrgent == false ? AppColors.textHint : AppColors.error,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isUrgent == false
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color:
                isUrgent == false
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleText(
            text: project.unitDetails?.projectName ?? "",
            fontWeight: FontWeight.bold,
            maxLines: 2,
            color: isUrgent == false ? AppColors.textPrimary : AppColors.error,
          ),

          //  const SizedBox(height: AppDimensions.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              project.unitCode != null
                  ? Expanded(
                    child: CustomText(
                      text: "${project.unitCode}",
                      fontWeight: FontWeight.w500,
                    ),
                  )
                  : SizedBox.shrink(),
              const SizedBox(width: 8),
              project.status != null
                  ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      text: project.status ?? "",
                      color: statusColor,
                    ),
                  )
                  : SizedBox.shrink(),
            ],
          ),
          //  const SizedBox(height: AppDimensions.md),
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
                      child: CustomText(
                        text:
                            project.completeAddress ??
                            project.unitDetails?.districtName ??
                            "No Address Found",
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),

              //    const SizedBox(width: AppDimensions.md),

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GradientButton(
                text:
                    isShowingCalendar == false
                        ? "Update Current Status"
                        : "View Images",
                onPressed: onPressed,
              ),
            ],
          ),
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
