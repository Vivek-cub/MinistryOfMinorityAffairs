import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/status_tag.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class ProjectDetailsBottomSheet extends StatelessWidget {
  final UnitDetails project;

  const ProjectDetailsBottomSheet({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final title = _firstValue([
      project.projectName,
      project.unitProject?.projectName,
      project.projectUniqueId,
      project.unitCode,
      'Project Details',
    ]);

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.md),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
              ),
              // CustomText(text: project.unitProject?.msdpItemsName ?? ""),
              const SizedBox(height: AppDimensions.lg),
              _DetailRow(
                label: 'Msdp Name',
                value: project.unitProject?.msdpItemsName,
              ),
              _DetailRow(label: 'Project ID', value: project.projectUniqueId),
              _DetailRow(label: 'Unit ID', value: project.unitCode),

              _DetailRow(
                label: 'Status',
                customWidget:
                    _hasValue(project.status)
                        ? StatusTag(status: project.status ?? '')
                        : null,
              ),
              _DetailRow(label: 'Approval Year', value: project.year),
              _DetailRow(label: 'Address', value: project.address),
              _DetailRow(
                label: 'State',
                value: _firstValue([
                  project.unitProject?.stateName,
                  project.stateName,
                ]),
              ),
              _DetailRow(
                label: 'District',
                value: _firstValue([
                  project.unitProject?.districtName,
                  project.districtName,
                ]),
              ),
              _DetailRow(
                label: 'Block',
                value: _firstValue([
                  project.unitProject?.blockTownName,
                  project.blockTownName,
                  project.blockName,
                ]),
              ),
              _DetailRow(
                label: 'Units Functional',
                value:
                    project.noOfUnitsFunctional == null
                        ? "0"
                        : project.noOfUnitsFunctional == -1
                        ? "0"
                        : project.noOfUnitsFunctional.toString(),
              ),
              _DetailRow(
                label: 'Location',
                value: project.address == null ? null : project.address ?? "",
              ),
              _DetailRow(
                label: 'Created On',
                value:
                    project.createdAt == null
                        ? null
                        : Helpers.formatDateMedium(project.createdAt!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _firstValue(List<String?> values) {
    for (final value in values) {
      if (_hasValue(value)) return value!.trim();
    }
    return '';
  }

  static bool _hasValue(String? value) =>
      value != null && value.trim().isNotEmpty;
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? customWidget;

  const _DetailRow({required this.label, this.value, this.customWidget});

  @override
  Widget build(BuildContext context) {
    if (customWidget == null && !_hasValue(value)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomText(
              text: label,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(flex: 3, child: _buildValue()),
        ],
      ),
    );
  }

  Widget _buildValue() {
    if (customWidget != null) {
      return Align(alignment: Alignment.centerRight, child: customWidget);
    }

    return Text(
      value ?? '',
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: 'Montserrat',
      ),
    );
  }

  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}
