/// Project/Work model
class ProjectModel {
  final String id;
  final String title;
  final String location;
  final String status;
  final DateTime updatedAt;
  final bool isGeotagged;
  final String? department;

  ProjectModel({
    required this.id,
    required this.title,
    required this.location,
    required this.status,
    required this.updatedAt,
    required this.isGeotagged,
    this.department,
  });

  String get statusLabel {
    switch (status) {
      case 'in_progress':
        return 'Work in Progress';
      case 'not_started':
        return 'Not Started';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Updated ${years == 1 ? '1 year' : '$years years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Updated ${months == 1 ? '1 month' : '$months months'} ago';
    } else if (difference.inDays > 0) {
      return 'Updated ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return 'Updated ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return 'Updated ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Updated just now';
    }
  }
}

/// Dashboard statistics model
class DashboardStats {
  final int totalAssigned;
  final int inProgress;
  final int notStarted;
  final int completed;
  final int geotagged;
  final int nonGeotagged;

  DashboardStats({
    required this.totalAssigned,
    required this.inProgress,
    required this.notStarted,
    required this.completed,
    required this.geotagged,
    required this.nonGeotagged,
  });
}
