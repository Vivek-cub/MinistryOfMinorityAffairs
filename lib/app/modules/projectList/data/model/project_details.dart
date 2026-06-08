import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';
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
    final project = _asMap(json['project']);
    final attachments = _attachmentMilestones(json['attachments']);

    return ProjectDetails(
      id: _stringValue(json['Id']),
      projectUniqueId: _stringValue(
        project?['projectUniqueId'] ??
            json['projectUniqueId'] ??
            json['unitCode'],
      ),
      districtId: _stringValue(json['districtId'] ?? project?['districtId']),
      sectorId: _stringValue(json['sectorId'] ?? project?['sectorId']),
      projectTypeId: _stringValue(
        json['projectTypeId'] ?? project?['projectTypeId'],
      ),
      status: _stringValue(json['status'] ?? project?['status']),
      unitCount: _stringValue(
        json['unitCount'] ?? project?['unitCount'] ?? project?['nUnits'],
      ),
      visitCount: _parseInt(json['visitCount'] ?? project?['visitCount']),
      projectName: _stringValue(
        json['titleOrProjectName'] ??
            project?['projectName'] ??
            json['projectName'],
      ),
      year: _stringValue(json['year'] ?? project?['year']),
      lat: _parseDouble(json['lat'] ?? project?['lat']),
      lng: _parseDouble(json['lng'] ?? project?['lng']),
      address: _stringValue(
        json['completeAddress'] ?? json['address'] ?? project?['address'],
      ),
      createdBy: _stringValue(json['createdBy'] ?? project?['createdBy']),
      updatedBy: _stringValue(json['updatedBy'] ?? project?['updatedBy']),
      createdAt: _parseDate(json['createdAt'] ?? project?['createdAt']),
      updatedAt: _parseDate(json['updatedAt'] ?? project?['updatedAt']),
      milestones: attachments.isNotEmpty
          ? attachments
          : (json['projectMilestones'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(ProjectMilestone.fromJson)
              .toList(),
      videoAtt: _stringValue(json['videoAtt']),
    );
  }

  static List<ProjectMilestone> _attachmentMilestones(dynamic value) {
    final attachments = value as List<dynamic>? ?? const [];
    final imageGroups = <String, List<String>>{};

    for (final item in attachments.whereType<Map<String, dynamic>>()) {
      if (item['attachmentType'] != 'image') continue;

      final path = _stringValue(item['path']);
      if (path == null || path.trim().isEmpty) continue;

      final date = _stringValue(item['createdAt']) ?? '';
      imageGroups.putIfAbsent(date, () => <String>[]).add(path);
    }

    if (imageGroups.isEmpty) return const [];

    return [
      ProjectMilestone(
        imageAtt:
            imageGroups.entries
                .map(
                  (entry) =>
                      ImageAttachment(date: entry.key, images: entry.value),
                )
                .toList(),
      ),
    ];
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
