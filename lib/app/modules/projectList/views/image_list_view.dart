import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/state_manager.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/title_text.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/work_progress_header.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/milestone_card.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/controller/image_list_controller.dart';
import 'package:ministry_of_minority_affairs/app/utils/assets.dart';
import 'package:ministry_of_minority_affairs/app/utils/helpers.dart';

class ImageListView extends GetView<ImageListController> {
  const ImageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.background,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              WorkProgressHeader(
                //title: controller.screenTitle,
                title: "Images",
                subtitle: 'Track Progress of works in real-time',
                avatarAssetPath: ImageAssets.emblemImage,
                backIcon: Icons.arrow_back,
                // widget: WorkDetailInfoWidget(
                //   project: controller.data.value,
                //   status: controller.projectStatus.value,
                // ),
              ),

              Obx(() {
                final groupedData = controller.groupImages(
                  controller.data.value.imageAtt ?? [],
                );

                return Expanded(
                  child: ListView.builder(
                    itemCount: groupedData.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, dateIndex) {
                      final group = groupedData[dateIndex];
                      final progress = _parseProgress(group.progress);
                      final progressText = _formatProgress(group.progress);
                      final statusText = _cleanText(group.status);

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: TitleText(text: group.date)),
                                  if (statusText != null ||
                                      (progress == null &&
                                          progressText != null))
                                    Flexible(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          alignment: WrapAlignment.end,
                                          children: [
                                            if (progress == null &&
                                                progressText != null)
                                              _AttachmentBadge(
                                                label: progressText,
                                                color: AppColors.info,
                                                backgroundColor: AppColors.info
                                                    .withValues(alpha: 0.12),
                                              ),
                                            if (statusText != null)
                                              _AttachmentBadge(
                                                label: statusText,
                                                color: _statusColor(statusText),
                                                backgroundColor: _statusColor(
                                                  statusText,
                                                ).withValues(alpha: 0.12),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (progress != null) ...[
                                const SizedBox(height: 10),
                                MilestoneProgress(progress: progress),
                              ],
                              const SizedBox(height: 12),

                              ...group.roleGroups.entries.map((roleEntry) {
                                final role = roleEntry.key;
                                final images = roleEntry.value;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: "Uploaded By :- $role"),

                                    const SizedBox(height: 8),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: images.length,
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                      itemBuilder: (context, imageIndex) {
                                        final attachment = images[imageIndex];
                                        final imageUrl = Helpers()
                                            .resolveImageUrl(
                                              attachment.images ?? "",
                                            );

                                        return _ImageTile(
                                          imageUrl: imageUrl,
                                          onTap:
                                              () => controller.openImageViewer(
                                                context,
                                                images
                                                    .map(
                                                      (e) => Helpers()
                                                          .resolveImageUrl(
                                                            e.images ?? '',
                                                          ),
                                                    )
                                                    .toList(),
                                                imageIndex,
                                              ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 16),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const _ImageTile({
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: AppColors.lightGrey.withValues(alpha: 0.35),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.textSecondary,
                  size: 24,
                ),
              ),
        ),
      ),
    );
  }
}

class _AttachmentBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const _AttachmentBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 96),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}

String? _cleanText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

int? _parseProgress(String? value) {
  final text = _cleanText(value);
  if (text == null) return null;

  final progressMatch = RegExp(r'\d+(\.\d+)?').firstMatch(text);
  final numericProgress = double.tryParse(progressMatch?.group(0) ?? '');
  if (numericProgress != null) {
    return numericProgress.round().clamp(0, 100).toInt();
  }

  return null;
}

String? _formatProgress(String? value) {
  final text = _cleanText(value);
  if (text == null) return null;
  return text.toLowerCase().contains('progress') ? text : 'Progress $text';
}

Color _statusColor(String status) {
  switch (status.toLowerCase().replaceAll('_', ' ').trim()) {
    case 'completed':
      return AppColors.success;
    case 'in progress':
      return AppColors.warning;
    case 'not started':
      return AppColors.error;
    case 'assigned':
      return AppColors.info;
    default:
      return AppColors.textSecondary;
  }
}
