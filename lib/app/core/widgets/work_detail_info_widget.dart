import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';
import 'package:ministry_of_minority_affairs/app/data/models/project_model.dart';
import 'status_tag.dart';

/// Reusable widget for displaying work detail information
/// Shows Work ID, Status, State, District, Block, Work Type, Approval Year
class WorkDetailInfoWidget extends StatelessWidget {
  final ProjectModel project;

  const WorkDetailInfoWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            color: Colors.black.withOpacity(0.05),
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
            project.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // Work Details - Two Column Layout
          _buildDetailRow(
            label: 'Work ID:',
            value: project.id,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            label: 'Status:',
            value: null,
            customWidget: StatusTag(status: project.status),
          ),
          const SizedBox(height: 16),
          if (project.state != null)
            _buildDetailRow(
              label: 'State:',
              value: project.state!,
              showLocationIcon: true,
            ),
          if (project.state != null) const SizedBox(height: 16),
          if (project.district != null)
            _buildDetailRow(
              label: 'District:',
              value: project.district!,
            ),
          if (project.district != null) const SizedBox(height: 16),
          if (project.block != null)
            _buildDetailRow(
              label: 'Block:',
              value: project.block!,
            ),
          if (project.block != null) const SizedBox(height: 16),
          if (project.workType != null)
            _buildDetailRow(
              label: 'Work Type:',
              value: project.workType!,
            ),
          if (project.workType != null) const SizedBox(height: 16),
          if (project.approvalYear != null)
            _buildDetailRow(
              label: 'Approval Year:',
              value: project.approvalYear!,
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
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(width: 8),
        // Right column - Value
        Expanded(
          flex: 3,
          child: customWidget != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: customWidget,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (showLocationIcon)
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: AppColors.textPrimary,
                      ),
                    if (showLocationIcon) const SizedBox(width: 4),
                    Text(
                      value ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
