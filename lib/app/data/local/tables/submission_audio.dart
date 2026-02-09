
import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submissions.dart';

class SubmissionAudio extends Table {
  IntColumn get submissionId =>
      integer().references(Submissions, #id)();
  TextColumn get filePath => text()();
  IntColumn get durationMs => integer()();

  @override
  Set<Column> get primaryKey => {submissionId};
}
