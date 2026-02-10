
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';

class LocalProjectFull {
  final LocalProject project;
  final List<LocalMilestoneFull> milestones;

  LocalProjectFull({
    required this.project,
    required this.milestones,
  });
}

class LocalMilestoneFull {
  final LocalMilestone milestone;
  final List<String> images;
  final String? audio;
  final String? video;

  LocalMilestoneFull({
    required this.milestone,
    required this.images,
    this.audio,
    this.video,
  });
}
