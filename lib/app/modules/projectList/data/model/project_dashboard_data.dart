import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';

class ProjectDashboardData {
  final bool? geoTagged;
  final String? status;
  final String? sectorId;
  final String? projectUniqueId;
  final String? year;
  final String? yearId;
  final List<UserProject> projects;

  ProjectDashboardData({
    this.geoTagged,
    this.status,
    this.sectorId,
    this.projectUniqueId,
    this.year,
    this.yearId,
    required this.projects,
  });

  factory ProjectDashboardData.fromJson(Map<String, dynamic> json) {
    return ProjectDashboardData(
      geoTagged: json['geoTagged'],
      status: json['status'],
      sectorId: json['sectorId'],
      projectUniqueId: json['projectUniqueId'],
      year: json['year'],
      yearId: json['yearId'],
      projects:
          (json['projects'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(UserProject.fromJson)
              .toList(),
    );
  }
}
