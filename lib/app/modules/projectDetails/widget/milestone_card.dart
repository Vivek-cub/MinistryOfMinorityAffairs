import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_button.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/custom_text.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/widget/photo_viewer.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/milestone_attachment_mapper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/utils/network_constants.dart';
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
    final hasAttachments = false;
    // MilestoneAttachmentMapper.hasImages(milestone) ||
    // MilestoneAttachmentMapper.hasAudio(milestone);

    return milestoneStatus == "Completed" || hasAttachments
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

                const SizedBox(height: 10),
                _buildProgress(),

                const SizedBox(height: 12),

                // /// Attachments
                // hasAttachments ? _buildAttachments(context) : SizedBox.shrink(),

                // const SizedBox(height: 12),
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
                const SizedBox(height: 10),
                _buildProgress(),
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

  Widget _buildProgress() {
    final progress = (milestone.progress ?? 0).clamp(0, 100);

    return MilestoneProgress(progress: progress);
  }

  // Widget _buildAttachments(BuildContext context) {
  //   final imageGroups = MilestoneAttachmentMapper.imageGroups(milestone);
  //   final audioGroups = MilestoneAttachmentMapper.audioGroups(milestone);
  //   final attachmentGroups = <_AttachmentGroup>[];

  //   for (final group in imageGroups) {
  //     final dateText = (group.date ?? "");
  //     final images =
  //         (group.images ?? const <String>[])
  //             .where((path) => path.trim().isNotEmpty)
  //             .toList();
  //     if (images.isEmpty) continue;

  //     // final attachmentGroup = _groupForDate(attachmentGroups, dateText);
  //     //  attachmentGroup.images.addAll(images);
  //   }

  //   for (final group in audioGroups) {
  //     final dateText = (group.date ?? "").trim();
  //     final audios =
  //         (group.audios ?? const <String>[])
  //             .where((path) => path.trim().isNotEmpty)
  //             .toList();
  //     if (audios.isEmpty) continue;

  //     final attachmentGroup = _groupForDate(attachmentGroups, dateText);
  //     attachmentGroup.audios.addAll(audios);
  //   }

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children:
  //         attachmentGroups.map((group) {
  //           return Padding(
  //             padding: const EdgeInsets.only(bottom: 12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 if (group.date.isNotEmpty) ...[
  //                   CustomText(
  //                     text: group.date,
  //                     fontWeight: FontWeight.w600,
  //                     color: AppColors.textSecondary,
  //                     maxLines: 2,
  //                   ),
  //                   const SizedBox(height: 8),
  //                 ],
  //                 if (group.images.isNotEmpty) ...[
  //                   SizedBox(
  //                     height: 90,
  //                     child: ListView.separated(
  //                       scrollDirection: Axis.horizontal,
  //                       itemCount: group.images.length,
  //                       separatorBuilder: (_, __) => const SizedBox(width: 8),
  //                       itemBuilder: (_, i) {
  //                         final path = group.images[i];
  //                         final isRemote = !_isLocalPath(path);

  //                         return InkWell(
  //                           onTap: () {
  //                             openImageViewer(
  //                               context,
  //                               group.images
  //                                   .map(_resolveAttachmentUrl)
  //                                   .toList(),
  //                               i,
  //                             );
  //                           },
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(8),
  //                             child:
  //                                 isRemote
  //                                     ? Image.network(
  //                                       _resolveAttachmentUrl(path),
  //                                       width: 90,
  //                                       height: 90,
  //                                       fit: BoxFit.cover,
  //                                     )
  //                                     : Image.file(
  //                                       File(path),
  //                                       width: 90,
  //                                       height: 90,
  //                                       fit: BoxFit.cover,
  //                                     ),
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //                 if (group.audios.isNotEmpty) ...[
  //                   if (group.images.isNotEmpty) const SizedBox(height: 8),
  //                   ...group.audios.map(
  //                     (path) => Padding(
  //                       padding: const EdgeInsets.only(bottom: 8),
  //                       child: _AudioPlayerTile(path: path),
  //                     ),
  //                   ),
  //                 ],
  //               ],
  //             ),
  //           );
  //         }).toList(),
  //   );
  // }

  _AttachmentGroup _groupForDate(List<_AttachmentGroup> groups, String date) {
    for (final group in groups) {
      if (group.date == date) return group;
    }

    final group = _AttachmentGroup(date: date);
    groups.add(group);
    return group;
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

class _AttachmentGroup {
  final String date;
  final List<String> images = [];
  final List<String> audios = [];

  _AttachmentGroup({required this.date});
}

class MilestoneProgress extends StatelessWidget {
  final int progress;

  const MilestoneProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.toDouble()),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, _) {
        final roundedProgress = animatedProgress.round();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "Project Progress",
                  color: AppColors.textSecondary,
                ),
                CustomText(
                  text: "$roundedProgress%",
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: animatedProgress / 100,
                minHeight: 6,
                backgroundColor: AppColors.lightGrey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 100 ? Colors.green : AppColors.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AudioPlayerTile extends StatefulWidget {
  final String path;

  const _AudioPlayerTile({required this.path});

  @override
  State<_AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<_AudioPlayerTile> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
      }
      return;
    }

    final path = _resolveAttachmentUrl(widget.path);
    final source =
        _isRemotePath(path) ? UrlSource(path) : DeviceFileSource(path);

    await _player.play(source);
    if (mounted) {
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(
              _isPlaying ? Icons.stop : Icons.play_arrow,
              color: Colors.green,
            ),
            onPressed: _togglePlayback,
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Recorded Audio',
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

bool _isRemotePath(String path) =>
    path.startsWith('http://') || path.startsWith('https://');

bool _isLocalPath(String path) => path.trim().startsWith('/');

String _resolveAttachmentUrl(String path) {
  final cleanedPath = path.replaceAll('\\', '/').trim();
  if (_isRemotePath(cleanedPath) || _isLocalPath(cleanedPath)) {
    return cleanedPath;
  }

  final rawBaseUrl =
      NetworkConstants.baseUrl.replaceFirst('baseUrl=', '').trim();
  return Uri.parse(rawBaseUrl).resolve(cleanedPath).toString();
}
