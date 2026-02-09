
import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submissions.dart';

class SubmissionImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get submissionId =>
      integer().references(Submissions, #id)();
  TextColumn get filePath => text()();
}
