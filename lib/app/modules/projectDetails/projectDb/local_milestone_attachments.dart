
import 'package:drift/drift.dart';

class LocalMilestoneAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get projectId => text()();
  TextColumn get milestoneId => text()();

  /// image | audio | video
  TextColumn get type => text()();

  /// local file path
  TextColumn get filePath => text()();

  /// upload sync flag
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
