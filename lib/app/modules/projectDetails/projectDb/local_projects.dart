
import 'package:drift/drift.dart';

class LocalProjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get projectName => text()();
  TextColumn get status => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  TextColumn get districtId => text().nullable()();
  TextColumn get projectUniqueId => text()();

}
