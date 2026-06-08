import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_dashboard_data.dart';

class ProjectResponse {
  final String? statusCode;
  final String? statusMessage;
  final ProjectDashboardData? data;

  const ProjectResponse({
    this.statusCode,
    this.statusMessage,
    this.data,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    final responseData = json['data'];

    return ProjectResponse(
      statusCode: json['statusCode']?.toString(),
      statusMessage: json['statusMessage']?.toString(),
      data: responseData is Map<String, dynamic>
          ? ProjectDashboardData.fromJson(responseData)
          : null,
    );
  }
}
