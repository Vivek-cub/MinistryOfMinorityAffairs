import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/audio_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';

class ProjectMilestone {
  final String? id;
  final String? projectId;
  final String? milestoneName;
  final String? milestoneDescription;
  final DateTime? milestoneDate;
  final String? status;
  final int? progress;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final List<String>? imageAtt;
  // final String? audioAtt;
  final List<ImageAttachment>? imageAtt;
  final List<AudioAttachment>? audioAtt;

  ProjectMilestone({
    this.id,
    this.projectId,
    this.milestoneName,
    this.milestoneDescription,
    this.milestoneDate,
    this.status,
    this.progress,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.audioAtt,
    this.imageAtt,
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: json['Id'],
      projectId: json['projectId'],
      milestoneName: json['milestoneName'],
      milestoneDescription: json['milestoneDescription'],
      milestoneDate: DateTime.tryParse(json['milestoneDate'] ?? ''),
      status: json['status'],
      progress: json['progress'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      // imageAtt: List<String>.from(json['imageAtt'] ?? []),
      imageAtt:
          (json['imageAtt'] as List?)
              ?.map((e) => ImageAttachment.fromJson(e))
              .toList(),
      audioAtt:
          (json['audioAtt'] as List?)
              ?.map((e) => AudioAttachment.fromJson(e))
              .toList(),
      // audioAtt: json['audioAtt'],
    );
  }
}
