class ProjectMilestone {
  final String? id;
  final String? projectId;
  final String? milestoneName;
  final String? milestoneDescription;
  final DateTime? milestoneDate;
  final String? status;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String>? imageAtt;
  final String? audioAtt;
  final String? videoAtt;

  ProjectMilestone({
    this.id,
    this.projectId,
    this.milestoneName,
    this.milestoneDescription,
    this.milestoneDate,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    required this.imageAtt,
    this.audioAtt,
    this.videoAtt,
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: json['Id'],
      projectId: json['projectId'],
      milestoneName: json['milestoneName'],
      milestoneDescription: json['milestoneDescription'],
      milestoneDate: DateTime.tryParse(json['milestoneDate'] ?? ''),
      status: json['status'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      imageAtt: List<String>.from(json['imageAtt'] ?? []),
      audioAtt: json['audioAtt'],
      videoAtt: json['videoAtt'],
    );
  }
}
