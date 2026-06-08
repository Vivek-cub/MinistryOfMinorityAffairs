import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

class UserProject {
  final String? id;
  final String? userId;
  final String? projectId;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ProjectDetails? project;

  UserProject({
    this.id,
    this.userId,
    this.projectId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.project,
  });

  factory UserProject.fromJson(Map<String, dynamic> json) {
    final projectJson = json['unitDetails'] ?? json['project'];

    return UserProject(
      id: _stringValue(json['Id']),
      userId: _stringValue(json['userId']),
      projectId: _stringValue(json['projectId']),
      status: _stringValue(json['status']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      project:
          projectJson is Map<String, dynamic>
              ? ProjectDetails.fromJson({
                ...projectJson,
                'status': projectJson['status'] ?? json['status'],
              })
              : null,
    );
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
