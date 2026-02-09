import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
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
    bool isSynced = false
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
      isSynced: isSynced,
    );
  }

  // 🔁 For auto-sync
  Future<List<PendingSubmission>> getPending() {
    return dao.getPendingSubmissions();
  }

  Future<void> markAsSynced(int id) {
    return dao.markAsSynced(id);
  }
}
