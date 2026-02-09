import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submissions.dart';

class SubmissionRemarks extends Table {
  IntColumn get submissionId =>
      integer().references(Submissions, #id)();
  TextColumn get remarks => text()();

  @override
  Set<Column> get primaryKey => {submissionId};
}
