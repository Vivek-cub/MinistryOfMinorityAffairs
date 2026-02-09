import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/user_project.dart';

class ProjectDashboardData {
  final bool? geoTagged;
  final String? status;
  final List<UserProject> projects;

  ProjectDashboardData({
    this.geoTagged,
    this.status,
    required this.projects,
  });

  factory ProjectDashboardData.fromJson(Map<String, dynamic> json) {
    return ProjectDashboardData(
      geoTagged: json['geoTagged'],
      status: json['status'],
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => UserProject.fromJson(e))
          .toList(),
    );
  }
}
