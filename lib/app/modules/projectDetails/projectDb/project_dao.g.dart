// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dao.dart';

// ignore_for_file: type=lint
mixin _$ProjectDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalProjectsTable get localProjects => attachedDatabase.localProjects;
  $LocalMilestonesTable get localMilestones => attachedDatabase.localMilestones;
  $LocalMilestoneAttachmentsTable get localMilestoneAttachments =>
      attachedDatabase.localMilestoneAttachments;
  ProjectDaoManager get managers => ProjectDaoManager(this);
}

class ProjectDaoManager {
  final _$ProjectDaoMixin _db;
  ProjectDaoManager(this._db);
  $$LocalProjectsTableTableManager get localProjects =>
      $$LocalProjectsTableTableManager(_db.attachedDatabase, _db.localProjects);
  $$LocalMilestonesTableTableManager get localMilestones =>
      $$LocalMilestonesTableTableManager(
        _db.attachedDatabase,
        _db.localMilestones,
      );
  $$LocalMilestoneAttachmentsTableTableManager get localMilestoneAttachments =>
      $$LocalMilestoneAttachmentsTableTableManager(
        _db.attachedDatabase,
        _db.localMilestoneAttachments,
      );
}
