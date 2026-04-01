
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';

class SubmissionRepository {
  final SubmissionDao dao;
  SubmissionRepository(this.dao);

  Future<void> save({
    required String userId,
    required String projectId,
    required String milestoneId,
    required List<String> images,
    String? audioPath,
    int? audioDuration,
    String? videoPath,
    int? videoDuration,
    required String remarks,
    bool isSynced = false,
    String? userLat,
    String? userLng,
    String? progress,
    String? projectStatus,
  }) {
    return dao.saveSubmission(
      userId: userId,
      projectId: projectId,
      milestoneId: milestoneId,
      images: images,
      audioPath: audioPath,
      audioDuration: audioDuration,
      videoPath: videoPath,
      videoDuration: videoDuration,
      remarks: remarks,
      isSynced: isSynced,
      userLat: userLat,
      userLng: userLng,
      progress: progress,
      projectStatus: projectStatus,
    );
  }

  Future<List<PendingSubmission>> getPending({
    required String userId,
  }) {
    return dao.getPendingSubmissions(userId);
  }

  Future<void> markAsSynced(int submissionId, String userId) {
    return dao.markAsSynced(submissionId, userId);
  }

  Future<PendingSubmission?> getDraftByProjectAndMilestone({
    required String userId,
    required String projectId,
    required String milestoneId,
  }) {
    return dao.getDraftByProjectAndMilestone(
      userId: userId,
      projectId: projectId,
      milestoneId: milestoneId,
    );
  }

  Future<void> clearLocalDataForUser(String userId) {
    return dao.clearLocalDataForUser(userId);
  }
}
