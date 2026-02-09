// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submission_dao.dart';

// ignore_for_file: type=lint
mixin _$SubmissionDaoMixin on DatabaseAccessor<AppDatabase> {
  $SubmissionsTable get submissions => attachedDatabase.submissions;
  $SubmissionImagesTable get submissionImages =>
      attachedDatabase.submissionImages;
  $SubmissionAudioTable get submissionAudio => attachedDatabase.submissionAudio;
  $SubmissionVideoTable get submissionVideo => attachedDatabase.submissionVideo;
  $SubmissionRemarksTable get submissionRemarks =>
      attachedDatabase.submissionRemarks;
  SubmissionDaoManager get managers => SubmissionDaoManager(this);
}

class SubmissionDaoManager {
  final _$SubmissionDaoMixin _db;
  SubmissionDaoManager(this._db);
  $$SubmissionsTableTableManager get submissions =>
      $$SubmissionsTableTableManager(_db.attachedDatabase, _db.submissions);
  $$SubmissionImagesTableTableManager get submissionImages =>
      $$SubmissionImagesTableTableManager(
        _db.attachedDatabase,
        _db.submissionImages,
      );
  $$SubmissionAudioTableTableManager get submissionAudio =>
      $$SubmissionAudioTableTableManager(
        _db.attachedDatabase,
        _db.submissionAudio,
      );
  $$SubmissionVideoTableTableManager get submissionVideo =>
      $$SubmissionVideoTableTableManager(
        _db.attachedDatabase,
        _db.submissionVideo,
      );
  $$SubmissionRemarksTableTableManager get submissionRemarks =>
      $$SubmissionRemarksTableTableManager(
        _db.attachedDatabase,
        _db.submissionRemarks,
      );
}
