import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';
import '../theme/theme_constants.dart';
import 'status_tag.dart';

/// Reusable widget for displaying work detail information
/// Shows Work ID, Status, State, District, Block, Work Type, Approval Year
class WorkDetailInfoWidget extends StatelessWidget {
  final ProjectDetails project;
  final String status;

  const WorkDetailInfoWidget({
    super.key,
    required this.project,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    print("Status $status");
    return Container(
      margin: EdgeInsets.only(
        left: AppDimensions.sm,
        right: AppDimensions.sm,
        top: AppDimensions.sm,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            project.projectName ?? "",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Work Details - Two Column Layout
          _buildDetailRow(label: 'Project UID', value: project.projectUniqueId),
          project.year != null ? const SizedBox(height: 16) : SizedBox.shrink(),
          project.year != null
              ? _buildDetailRow(
                label: 'Approval Year',
                value: project.year ?? "",
              )
              : SizedBox.shrink(),
          project.status != null
              ? const SizedBox(height: 16)
              : SizedBox.shrink(),
          project.status != null
              ? _buildDetailRow(
                label: 'Status',
                value: null,
                customWidget: StatusTag(status: status),
              )
              : SizedBox.shrink(),
          const SizedBox(height: 16),
          if (project.address != null)
            _buildDetailRow(
              label: 'Address',
              value: project.address ?? "",
              showLocationIcon: true,
            ),
          if (project.districtId != null) const SizedBox(height: 16),
          if (project.districtId != null)
            _buildDetailRow(label: 'District', value: project.districtId),
          if (project.address != null) const SizedBox(height: 16),
          if (project.address != null)
            _buildDetailRow(label: 'Block', value: project.address),

          if (project.visitCount != null) const SizedBox(height: 16),
          if (project.visitCount != null)
            _buildDetailRow(
              label: 'Officer Visit Count',
              value: project.visitCount.toString(),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    String? value,
    Widget? customWidget,
    bool showLocationIcon = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left column - Label
        Expanded(
          flex: 2,
          child: CustomText(
            text: label,
            color: AppColors.textHint,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.left,
          ),
        ),

        const SizedBox(width: 8),

        // Right column - Value
        Expanded(
          flex: 3,
          child:
              customWidget != null
                  ? Align(alignment: Alignment.centerRight, child: customWidget)
                  : Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showLocationIcon) ...[
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 4),
                        ],

                        Flexible(
                          child: CustomText(
                            text: value ?? 'N/A',
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}
