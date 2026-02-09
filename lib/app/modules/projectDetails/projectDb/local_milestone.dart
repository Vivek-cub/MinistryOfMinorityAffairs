
import 'package:drift/drift.dart';

class LocalMilestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get milestoneId => text()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
}
