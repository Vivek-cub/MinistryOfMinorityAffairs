import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'dart:io';

class MilestoneCard extends StatelessWidget {
  ProjectMilestone milestone;
  int imageCount;
  MilestoneCard({required this.milestone, required this.imageCount});

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

                /// Images
                (milestone.imageAtt != [] || milestone.imageAtt != null)
                    ? _buildImages()
                    : SizedBox.shrink(),

                // /// Audio
                // (milestone.audioAtt != null) ? _buildAudio():SizedBox.shrink(),

                // /// Video
                // (milestone.videoAtt != null)? _buildVideo():SizedBox.shrink(),
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
              ],
            ),
          ),
        );
  }

  Widget _buildImages() {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: milestone.imageAtt?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final path = milestone.imageAtt![i];
          final isRemote =
              path.startsWith('http://') || path.startsWith('https://');

          return ClipRRect(
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
          );
        },
      ),
    );
  }

  Widget _buildAudio() {
    return ListTile(
      leading: const Icon(Icons.audiotrack),
      title: const Text("Audio Attachment"),
      onTap: () {
        // open audio player
      },
    );
  }

  Widget _buildVideo() {
    return ListTile(
      leading: const Icon(Icons.videocam),
      title: const Text("Video Attachment"),
      onTap: () {
        // open video player
      },
    );
  }
}
