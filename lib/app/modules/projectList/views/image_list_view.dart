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
import 'package:video_player/video_player.dart';

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
                                final attachments = roleEntry.value;
                                final imageUrls = attachments
                                    .where(_isImageAttachment)
                                    .map(
                                      (attachment) => Helpers()
                                          .resolveImageUrl(
                                            attachment.images ?? '',
                                          ),
                                    )
                                    .toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(text: "Uploaded By :- $role"),

                                    const SizedBox(height: 8),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: attachments.length,
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                          ),
                                      itemBuilder: (context, imageIndex) {
                                        final attachment =
                                            attachments[imageIndex];
                                        final attachmentUrl = Helpers()
                                            .resolveImageUrl(
                                              attachment.images ?? '',
                                            );

                                        if (_isVideoAttachment(attachment)) {
                                          return _VideoTile(
                                            videoUrl: attachmentUrl,
                                          );
                                        }

                                        final imageIndexInViewer =
                                            attachments
                                                .take(imageIndex + 1)
                                                .where(_isImageAttachment)
                                                .length -
                                            1;
                                        return _ImageTile(
                                          imageUrl: attachmentUrl,
                                          onTap:
                                              () => controller.openImageViewer(
                                                context,
                                                imageUrls,
                                                imageIndexInViewer,
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

class _VideoTile extends StatefulWidget {
  final String videoUrl;

  const _VideoTile({
    required this.videoUrl,
  });

  @override
  State<_VideoTile> createState() => _VideoTileState();
}

class _VideoTileState extends State<_VideoTile> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;
  bool _hasError = false;
  int _loadId = 0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(covariant _VideoTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller?.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _loadId++;
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final loadId = ++_loadId;

    setState(() {
      _isInitializing = true;
      _hasError = false;
      _controller = null;
    });

    VideoPlayerController? controller;
    try {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await controller.initialize();
      await controller.setLooping(true);

      if (!mounted || loadId != _loadId) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (_) {
      await controller?.dispose();
      if (!mounted || loadId != _loadId) return;
      setState(() {
        _isInitializing = false;
        _hasError = true;
      });
    }
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (controller != null && controller.value.isInitialized)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller.value.size.width,
                    height: controller.value.size.height,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            else
              Center(
                child: _isInitializing
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _hasError
                            ? Icons.videocam_off_outlined
                            : Icons.video_library_outlined,
                        color: AppColors.textWhite,
                        size: 28,
                      ),
              ),
            if (controller != null && controller.value.isInitialized)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _togglePlayback,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: AppColors.textWhite,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (controller != null && controller.value.isInitialized)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    playedColor: AppColors.primary,
                    bufferedColor: AppColors.lightGrey,
                    backgroundColor: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
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

bool _isImageAttachment(dynamic attachment) {
  return _attachmentType(attachment) == 'image';
}

bool _isVideoAttachment(dynamic attachment) {
  return _attachmentType(attachment) == 'video';
}

String? _attachmentType(dynamic attachment) {
  return attachment.attachmentType?.trim().toLowerCase();
}
