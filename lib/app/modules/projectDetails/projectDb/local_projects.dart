
import 'package:drift/drift.dart';

class LocalProjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get projectName => text()();
  TextColumn get status => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
}
