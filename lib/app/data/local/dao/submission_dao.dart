import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/core/database/pending_submission.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_audio.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_images.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_remarks.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_video.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submissions.dart';

part 'submission_dao.g.dart';

@DriftAccessor(
  tables: [
    Submissions,
    SubmissionImages,
    SubmissionAudio,
    SubmissionVideo,
    SubmissionRemarks,
  ],
)
class SubmissionDao extends DatabaseAccessor<AppDatabase>
    with _$SubmissionDaoMixin {
  SubmissionDao(AppDatabase db) : super(db);

  Future<void> saveSubmission({
    required String userId,
    required String projectId,
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
    String? questionnairePayload,
  }) async {
    await transaction(() async {
      final existing =
          await (select(submissions)..where(
            (t) => t.userId.equals(userId) & t.projectId.equals(projectId),
          )).getSingleOrNull();

      int submissionId;

      if (existing == null) {
        submissionId = await into(submissions).insert(
          SubmissionsCompanion.insert(
            userId: userId,
            projectId: projectId,
            isSynced: Value(isSynced),
            userLat: userLat ?? "",
            userLng: userLng ?? "",
            progress: progress ?? "",
            projectStatus: projectStatus ?? "",
            questionnairePayload: Value(questionnairePayload ?? ""),
          ),
        );
      } else {
        submissionId = existing.id;

        await (update(submissions)
          ..where((t) => t.id.equals(submissionId))).write(
          SubmissionsCompanion(
            isSynced: Value(isSynced),
            userLat: Value(userLat ?? ""),
            userLng: Value(userLng ?? ""),
            progress: Value(progress ?? ""),
            projectStatus: Value(projectStatus ?? ""),
            questionnairePayload: Value(questionnairePayload ?? ""),
          ),
        );

        await (delete(submissionImages)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionAudio)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionVideo)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionRemarks)
          ..where((t) => t.submissionId.equals(submissionId))).go();
      }

      await into(submissionRemarks).insert(
        SubmissionRemarksCompanion(
          submissionId: Value(submissionId),
          remarks: Value(remarks),
        ),
      );

      for (final img in images.toSet()) {
        await into(submissionImages).insert(
          SubmissionImagesCompanion(
            submissionId: Value(submissionId),
            filePath: Value(img),
          ),
        );
      }

      if (audioPath != null && audioPath.isNotEmpty) {
        await into(submissionAudio).insertOnConflictUpdate(
          SubmissionAudioCompanion(
            submissionId: Value(submissionId),
            filePath: Value(audioPath),
            durationMs: Value(audioDuration ?? 0),
          ),
        );
      }

      if (videoPath != null && videoPath.isNotEmpty) {
        await into(submissionVideo).insertOnConflictUpdate(
          SubmissionVideoCompanion(
            submissionId: Value(submissionId),
            filePath: Value(videoPath),
            durationMs: Value(videoDuration),
          ),
        );
      }
    });
  }

  // Future<List<Submission>> getPendingSubmissions() {
  //   return (select(submissions)
  //         ..where((tbl) => tbl.isSynced.equals(false)))
  //       .get();
  // }
  // Future<void> markAsSynced(int submissionId) {
  //   return (update(submissions)
  //         ..where((tbl) => tbl.id.equals(submissionId)))
  //       .write(
  //     SubmissionsCompanion(
  //       isSynced: const Value(true),
  //     ),
  //   );
  // }

  Future<List<PendingSubmission>> getPendingSubmissions(String userId) async {
    final pending =
        await (select(submissions)..where(
          (tbl) => tbl.isSynced.equals(false) & tbl.userId.equals(userId),
        )).get();

    final result = <PendingSubmission>[];

    for (final sub in pending) {
      final images =
          await (select(submissionImages)
            ..where((t) => t.submissionId.equals(sub.id))).get();

      final audio =
          await (select(submissionAudio)
            ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

      final video =
          await (select(submissionVideo)
            ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

      final remark =
          await (select(submissionRemarks)
            ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

      result.add(
        PendingSubmission(
          submission: sub,
          images: images,
          audio: audio,
          video: video,
          remark: remark,
        ),
      );
    }

    return result;
  }

  Future<void> markAsSynced(int submissionId, String userId) {
    return (update(submissions)..where(
      (t) => t.id.equals(submissionId) & t.userId.equals(userId),
    )).write(const SubmissionsCompanion(isSynced: Value(true)));
  }

  Future<PendingSubmission?> getDraftByProject({
    required String userId,
    required String projectId,
  }) async {
    final sub =
        await (select(submissions)..where(
          (t) =>
              t.userId.equals(userId) &
              t.projectId.equals(projectId) &
              t.isSynced.equals(false),
        )).getSingleOrNull();

    if (sub == null) return null;

    final images =
        await (select(submissionImages)
          ..where((t) => t.submissionId.equals(sub.id))).get();

    final audio =
        await (select(submissionAudio)
          ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

    final video =
        await (select(submissionVideo)
          ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

    final remark =
        await (select(submissionRemarks)
          ..where((t) => t.submissionId.equals(sub.id))).getSingleOrNull();

    return PendingSubmission(
      submission: sub,
      images: images,
      audio: audio,
      video: video,
      remark: remark,
    );
  }

  Future<void> clearLocalDataForUser(String userId) async {
    final userSubmissionIds =
        await (selectOnly(submissions)
              ..addColumns([submissions.id])
              ..where(submissions.userId.equals(userId)))
            .map((row) => row.read(submissions.id))
            .get();

    await transaction(() async {
      for (final submissionId in userSubmissionIds.whereType<int>()) {
        await (delete(submissionImages)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionAudio)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionVideo)
          ..where((t) => t.submissionId.equals(submissionId))).go();
        await (delete(submissionRemarks)
          ..where((t) => t.submissionId.equals(submissionId))).go();
      }

      await (delete(submissions)..where((t) => t.userId.equals(userId))).go();
    });
  }

  Future<void> deleteSubmissionWithAttachments(
    int submissionId,
    String userId,
  ) async {
    await transaction(() async {
      await (delete(submissionImages)
        ..where((t) => t.submissionId.equals(submissionId))).go();
      await (delete(submissionAudio)
        ..where((t) => t.submissionId.equals(submissionId))).go();
      await (delete(submissionVideo)
        ..where((t) => t.submissionId.equals(submissionId))).go();
      await (delete(submissionRemarks)
        ..where((t) => t.submissionId.equals(submissionId))).go();
      await (delete(submissions)..where(
        (t) => t.id.equals(submissionId) & t.userId.equals(userId),
      )).go();
    });
  }
}
