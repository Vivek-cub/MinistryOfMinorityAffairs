import 'package:drift/drift.dart';

class Submissions extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get projectId => text()();

  TextColumn get milestoneId => text()();

  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

