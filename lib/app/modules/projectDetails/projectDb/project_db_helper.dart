import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';

class LocalProjectFull {
  final LocalProject project;
  final List<LocalMilestoneFull> milestones;
  final String? video;

  LocalProjectFull({
    required this.project,
    required this.milestones,
    this.video,
  });
}

class LocalMilestoneFull {
  final LocalMilestone milestone;
  final List<String> images;
  final List<String>? audio;
  final String? video;

  LocalMilestoneFull({
    required this.milestone,
    required this.images,
    this.audio,
    this.video,
  });
}
