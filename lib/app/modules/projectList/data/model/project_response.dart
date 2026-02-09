
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_dashboard_data.dart';

class ProjectResponse {
  final String? statusCode;
  final String? statusMessage;
  final ProjectDashboardData? data;

  ProjectResponse({
    this.statusCode,
    this.statusMessage,
    this.data,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      data: json['data'] != null
          ? ProjectDashboardData.fromJson(json['data'])
          : null,
    );
  }
}
