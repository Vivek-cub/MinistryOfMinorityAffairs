
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';

class SubmissionRepository {
  final SubmissionDao dao;
  SubmissionRepository(this.dao);

  Future<void> save({
    required String projectId,
    required String milestoneId,
    required List<String> images,
    String? audioPath,
    int? audioDuration,
    String? videoPath,
    int? videoDuration,
    required String remarks,
  }) {
    return dao.saveSubmission(
      projectId: projectId,
      milestoneId: milestoneId,
      images: images,
      audioPath: audioPath,
      audioDuration: audioDuration,
      videoPath: videoPath,
      videoDuration: videoDuration,
      remarks: remarks,
    );
  }
}
