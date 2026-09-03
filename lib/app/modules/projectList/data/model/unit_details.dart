import 'package:flutter/cupertino.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/image_attachment.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_project.dart';

class UnitDetails {
  final String? id;
  final String? projectUniqueId;
  final String? districtId;
  final String? sectorId;
  final String? projectTypeId;
  final String? status;
  final String? unitCount;
  final String? unitCode;
  final int? visitCount;
  final String? projectName;
  final String? year;
  final double? lat;
  final double? lng;
  final String? address;
  final String? createdBy;
  final String? updatedBy;
  final String? blockTownName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // final List<ProjectMilestone>? milestones;
  final UnitProject? unitProject;
  final List<ImageAttachment>? imageAtt;
  final String? videoAtt;
  final String? districtName;
  final String? stateName;
  final String? blockName;
  final String? msdpSectorName;
  final int? noOfUnitsFunctional;

  UnitDetails({
    this.id,
    this.projectUniqueId,
    this.districtId,
    this.sectorId,
    this.projectTypeId,
    this.status,
    this.unitCount,
    this.unitCode,
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
    this.blockTownName,
    this.imageAtt,
    this.unitProject,
    //this.milestones = const [],
    this.videoAtt,
    this.districtName,
    this.blockName,
    this.stateName,
    this.msdpSectorName,
    this.noOfUnitsFunctional,
  });

  factory UnitDetails.fromJson(Map<String, dynamic> json) {
    final project = _asMap(json['project']);
    final responseData = json['project'];
    // final attachments = _attachmentMilestones(json['attachments']);

    return UnitDetails(
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
      unitCode: _stringValue(json['unitCode'] ?? project?['unitCode']) ?? "",
      visitCount: _parseInt(json['visitCount'] ?? project?['visitCount']),
      projectName: _stringValue(
        json['titleOrProjectName'] ??
            project?['titleOrProjectName'] ??
            project?['projectName'] ??
            json['projectName'] ??
            json['title'] ??
            project?['title'] ??
            json['name'] ??
            project?['name'],
      ),
      year: _stringValue(json['year'] ?? project?['year']),
      lat: _parseDouble(json['lat'] ?? project?['lat']),
      lng: _parseDouble(json['lng'] ?? project?['lng']),
      address: _stringValue(
        json['completeAddress'] ??
            json['completeAddress'] ??
            project?['completeAddress'],
      ),
      createdBy: _stringValue(json['createdBy'] ?? project?['createdBy']),
      updatedBy: _stringValue(json['updatedBy'] ?? project?['updatedBy']),
      blockTownName: _stringValue(json['blockTownName']),
      createdAt: _parseDate(json['createdAt'] ?? project?['createdAt']),
      updatedAt: _parseDate(json['updatedAt'] ?? project?['updatedAt']),
      // milestones:
      //     attachments.isNotEmpty
      //         ? attachments
      //         : (json['projectMilestones'] as List<dynamic>? ?? [])
      //             .whereType<Map<String, dynamic>>()
      //             .map(ProjectMilestone.fromJson)
      //             .toList(),
      imageAtt:
          (json['attachments'] as List?)
              ?.map((e) => ImageAttachment.fromJson(e))
              .toList(),
      videoAtt: _stringValue(json['videoAtt']),
      unitProject:
          responseData is Map<String, dynamic>
              ? UnitProject.fromJson(responseData)
              : null,
      districtName: _stringValue(json['districtName']),
      stateName: _stringValue(json['stateName']),
      blockName: _stringValue(json['blockName']),
      msdpSectorName: _stringValue(json['msdpSectorName']),
      noOfUnitsFunctional: _parseInt(json["noOfUnitsFunctional"] ?? -1),
    );
  }

  // static List<ProjectMilestone> _attachmentMilestones(dynamic value) {
  //   final attachments = value as List<dynamic>? ?? const [];
  //   final imageGroups = <String, List<String>>{};

  //   for (final item in attachments.whereType<Map<String, dynamic>>()) {
  //     if (item['attachmentType'] != 'image') continue;

  //     final path = _stringValue(item['path']);
  //     if (path == null || path.trim().isEmpty) continue;

  //     final date = _stringValue(item['createdAt']) ?? '';
  //     imageGroups.putIfAbsent(date, () => <String>[]).add(path);
  //   }

  //   if (imageGroups.isEmpty) return const [];

  //   return [
  //     ProjectMilestone(
  //       imageAtt:
  //           imageGroups.entries
  //               .map(
  //                 (entry) =>
  //                     ImageAttachment(date: entry.key, images: entry.value),
  //               )
  //               .toList(),
  //     ),
  //   ];
  // }

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
