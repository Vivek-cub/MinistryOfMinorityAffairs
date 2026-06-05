import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/auth/views/widgets/auth_submit_button.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class BuildProjectCard extends StatelessWidget {
  final ProjectDetails project;
  final VoidCallback? onPressed;
  bool? isUrgent = false;
  BuildProjectCard(this.project, this.onPressed, this.isUrgent);
  @override
  Widget build(BuildContext context) {
    return buildProjectCard(project, onPressed);
  }

  Widget buildProjectCard(ProjectDetails project, VoidCallback? onPressed) {
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
        children: [
          TitleText(
            text: project.projectName ?? "",
            fontWeight: FontWeight.bold,
            maxLines: 2,
            color: isUrgent == false ? AppColors.textPrimary : AppColors.error,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  text: "${project.projectUniqueId}" ?? "",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
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
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                        text: project.address ?? "",
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: Helpers.formatDateMedium(
                      project.createdAt ?? DateTime.now(),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
          if (project.districtId != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: AppColors.textPrimary),
                const SizedBox(width: 4),
                CustomText(text: project.districtId ?? ""),
              ],
            ),
          ],
          const SizedBox(height: 16),
          AuthSubmitButton(
            title: "Update Progress",
            isEnabled: true,
            height: 44,
            onPressed: onPressed,
            isUrgent: isUrgent ?? false,
          ),
        ],
      ),
    );
  }
}
