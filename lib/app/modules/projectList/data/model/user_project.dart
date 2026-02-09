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
    return UserProject(
      id: json['Id'],
      userId: json['userId'],
      projectId: json['projectId'],
      status: json['status'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      project: json['project'] != null
          ? ProjectDetails.fromJson(json['project'])
          : null,
    );
  }
}
