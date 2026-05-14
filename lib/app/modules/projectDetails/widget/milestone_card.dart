import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_button.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/photo_viewer.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/milestone_attachment_mapper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'dart:io';

class MilestoneCard extends StatelessWidget {
  final ProjectMilestone milestone;
  final int imageCount;
  final VoidCallback? onPressed;
  final bool? showAddProgress;
  MilestoneCard({
    super.key,
    required this.milestone,
    required this.imageCount,
    required this.onPressed,
    required this.showAddProgress,
  });

  @override
  Widget build(BuildContext context) {
    String milestoneStatus = "";
    if (milestone.status == "Completed") {
      milestoneStatus = "Completed";
    } else {
      milestoneStatus = "In-Progress";
    }
    return milestoneStatus == "Completed" || imageCount > 0
        ? Card(
          //margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.textSecondary, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      milestone.milestoneName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: AppDimensions.xs,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.s),
                        color:
                            milestoneStatus == "Completed"
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                      ),
                      child: CustomText(text: milestoneStatus),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(milestone.milestoneDescription ?? ""),

                const SizedBox(height: 12),

                /// Images
                (milestone.imageAtt != [] || milestone.imageAtt != null)
                    ? _buildImages(context)
                    : SizedBox.shrink(),

                const SizedBox(height: 12),

                showAddProgress == true
                    ? CustomButton(
                      title: "Add Progress +",
                      onPressed: onPressed,
                    )
                    : SizedBox.shrink(),

                // /// Audio
                // (milestone.audioAtt != null) ? _buildAudio():SizedBox.shrink(),

                // Project-level video is now handled on ProjectDetails.
              ],
            ),
          ),
        )
        : Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      milestone.milestoneName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(milestoneStatus),
                      backgroundColor:
                          milestoneStatus == "Completed"
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Text(milestone.milestoneDescription ?? ""),
                const SizedBox(height: 12),

                showAddProgress == true
                    ? CustomButton(
                      title: "Add Progress +",
                      onPressed: onPressed,
                    )
                    : SizedBox.shrink(),

                //const SizedBox(height: 12),
              ],
            ),
          ),
        );
  }

  Widget _buildImages(BuildContext context) {
    final imageGroups = MilestoneAttachmentMapper.imageGroups(milestone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          imageGroups.map((group) {
            final groupImages =
                (group.images ?? const <String>[])
                    .where((path) => path.trim().isNotEmpty)
                    .toList();

            if (groupImages.isEmpty) {
              return const SizedBox.shrink();
            }

            final dateText = (group.date ?? "").trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dateText.isNotEmpty) ...[
                    CustomText(
                      text: dateText,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: groupImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final path = groupImages[i];
                        final isRemote =
                            path.startsWith('http://') ||
                            path.startsWith('https://');

                        return InkWell(
                          onTap: () {
                            openImageViewer(context, groupImages, i);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                isRemote
                                    ? Image.network(
                                      path,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    )
                                    : Image.file(
                                      File(path),
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }

  void openImageViewer(BuildContext context, List<String> images, int index) {
    showDialog(
      context: context,
      barrierColor: AppColors.transparent,
      builder: (_) {
        return PhotoViewer(images: images, index: index);
      },
    );
  }
}
