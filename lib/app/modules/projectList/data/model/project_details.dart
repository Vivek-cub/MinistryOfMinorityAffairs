import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';

class ProjectDetails {
  final String? id;
  final String? projectUniqueId;
  final String? districtId;
  final String? sectorId;
  final String? projectTypeId;
  final String? status;
  final String? unitCount;
  final int? visitCount;
  final String? projectName;
  final String? year;
  final double? lat;
  final double? lng;
  final String? address;
  final String? createdBy;
  final String? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<ProjectMilestone>? milestones;
  final String? videoAtt;

  ProjectDetails({
    this.id,
    this.projectUniqueId,
    this.districtId,
    this.sectorId,
    this.projectTypeId,
    this.status,
    this.unitCount,
    this.visitCount,
    this.projectName,
    this.year,
    this.lat,
    this.lng,
    this.address,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.milestones = const [],
    this.videoAtt,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return ProjectDetails(
      id: json['Id'],
      projectUniqueId: json['projectUniqueId'],
      districtId: json['districtId'],
      sectorId: json['sectorId'],
      projectTypeId: json['projectTypeId'],
      status: json['status'],
      unitCount: json['unitCount'],
      visitCount: json['visitCount'],
      projectName: json['projectName'],
      year: json['year'],
      lat: _parseDouble(json['lat']),
      lng: _parseDouble(json['lng']),
      address: json['address'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      milestones:
          (json['projectMilestones'] as List<dynamic>? ?? [])
              .map((e) => ProjectMilestone.fromJson(e))
              .toList(),
      videoAtt: json['videoAtt'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
