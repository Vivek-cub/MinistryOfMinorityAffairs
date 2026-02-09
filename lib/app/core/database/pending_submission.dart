import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_audio.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_video.dart';

class PendingSubmission {
  final Submission submission;
  final List<SubmissionImage> images;
  final SubmissionAudioData? audio;
  final SubmissionVideoData? video;

  PendingSubmission({
    required this.submission,
    required this.images,
    this.audio,
    this.video,
  });
}

