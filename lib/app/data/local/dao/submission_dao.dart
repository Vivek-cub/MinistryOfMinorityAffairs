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
  required String projectId,
  required String milestoneId,
  required List<String> images,
  String? audioPath,
  int? audioDuration,
  String? videoPath,
  int? videoDuration,
  required String remarks,
  bool isSynced = false,
}) async {
  await transaction(() async {
    final submissionId = await into(submissions).insert(
      SubmissionsCompanion(
        projectId: Value(projectId),
        milestoneId: Value(milestoneId),
        isSynced: Value(isSynced),
      ),
    );

    await into(submissionRemarks).insert(
      SubmissionRemarksCompanion(
        submissionId: Value(submissionId),
        remarks: Value(remarks),
      ),
    );

    for (final img in images) {
      await into(submissionImages).insert(
        SubmissionImagesCompanion(
          submissionId: Value(submissionId),
          filePath: Value(img),
        ),
      );
    }

    if (audioPath != null) {
      await into(submissionAudio).insert(
        SubmissionAudioCompanion(
          submissionId: Value(submissionId),
          filePath: Value(audioPath),
          durationMs: Value(audioDuration ?? 0),
        ),
      );
    }

    if (videoPath != null) {
      await into(submissionVideo).insert(
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

Future<List<PendingSubmission>> getPendingSubmissions() async {
  final pending = await (select(submissions)
        ..where((tbl) => tbl.isSynced.equals(false)))
      .get();

  final result = <PendingSubmission>[];

  for (final sub in pending) {
    final images = await (select(submissionImages)
          ..where((t) => t.submissionId.equals(sub.id)))
        .get();

    final audio = await (select(submissionAudio)
          ..where((t) => t.submissionId.equals(sub.id)))
        .getSingleOrNull();

    final video = await (select(submissionVideo)
          ..where((t) => t.submissionId.equals(sub.id)))
        .getSingleOrNull();

    result.add(
      PendingSubmission(
        submission: sub,
        images: images,
        audio: audio,
        video: video,
      ),
    );
  }

  return result;
}

Future<void> markAsSynced(int submissionId) {
  return (update(submissions)
        ..where((t) => t.id.equals(submissionId)))
      .write(
    SubmissionsCompanion(isSynced: const Value(true)),
  );
}




}
