import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/unit_details.dart';

class UserProject {
  final String? id;
  final String? userId;
  final String? projectId;
  final String? status;
  final String? titleOrProjectName;
  final String? unitCode;
  final String? completeAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UnitDetails? unitDetails;

  UserProject({
    this.id,
    this.userId,
    this.projectId,
    this.status,
    this.titleOrProjectName,
    this.unitCode,
    this.completeAddress,
    this.createdAt,
    this.updatedAt,
    this.unitDetails,
  });

  factory UserProject.fromJson(Map<String, dynamic> json) {
    final projectJson = json['unitDetails'] ?? json['project'];

    return UserProject(
      id: _stringValue(json['Id']),
      userId: _stringValue(json['userId']),
      projectId: _stringValue(json['projectId']),
      status: _stringValue(json['status']),
      titleOrProjectName: _stringValue(json['titleOrProjectName']),
      unitCode: _stringValue(json['unitCode']),
      completeAddress: _stringValue(json['completeAddress']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      unitDetails:
          projectJson is Map<String, dynamic>
              ? UnitDetails.fromJson({
                ...projectJson,
                'status': projectJson['status'] ?? json['status'],
                'titleOrProjectName':
                    json['titleOrProjectName'] ??
                    projectJson['titleOrProjectName'],
                'unitCode': projectJson['unitCode'] ?? json['unitCode'],
                'completeAddress':
                    projectJson['completeAddress'] ?? json['completeAddress'],
              })
              : null,
    );
  }

  UnitDetails get displayUnitDetails =>
      unitDetails ??
      UnitDetails(
        id: projectId,
        projectName: titleOrProjectName,
        unitCode: unitCode,
        address: completeAddress,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
