import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone_attachments.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_projects.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [LocalProjects, LocalMilestones, LocalMilestoneAttachments])
class ProjectDao extends DatabaseAccessor<AppDatabase>
    with _$ProjectDaoMixin {

  ProjectDao(AppDatabase db) : super(db);

  Future<void> saveProject(ProjectDetails project) async {
  await transaction(() async {
    await into(localProjects).insertOnConflictUpdate(
      LocalProjectsCompanion(
        projectId: Value(project.id ?? ""),
        projectName: Value(project.projectName ?? ""),
        status: Value(project.status ?? ""),
        lat: Value(project.lat),
        lng: Value(project.lng),
      ),
    );

    await (delete(localMilestones)
          ..where((m) => m.projectId.equals(project.id??"")))
        .go();

    await (delete(localMilestoneAttachments)
          ..where((a) => a.projectId.equals(project.id??"")))
        .go();

    for (final m in project.milestones??[]) {
      await into(localMilestones).insert(
        LocalMilestonesCompanion(
          milestoneId: Value(m.id??""),
          projectId: Value(project.id ?? ""),
          name: Value(m.milestoneName??""),
          description: Value(m.milestoneDescription??""),
          status: Value(m.status??""),
        ),
      );

      for (final img in m.imageAtt ?? []) {
        await into(localMilestoneAttachments).insert(
          LocalMilestoneAttachmentsCompanion(
            projectId: Value(project.id ?? ""),
            milestoneId: Value(m.id),
            type: const Value('image'),
            filePath: Value(img),
          ),
        );
      }

      if (m.audioAtt != null && m.audioAtt!.isNotEmpty) {
        await into(localMilestoneAttachments).insert(
          LocalMilestoneAttachmentsCompanion(
            projectId: Value(project.id ?? ""),
            milestoneId: Value(m.id),
            type: const Value('audio'),
            filePath: Value(m.audioAtt!),
          ),
        );
      }

      if (m.videoAtt != null && m.videoAtt!.isNotEmpty) {
        await into(localMilestoneAttachments).insert(
          LocalMilestoneAttachmentsCompanion(
            projectId: Value(project.id ?? ""),
            milestoneId: Value(m.id),
            type: const Value('video'),
            filePath: Value(m.videoAtt!),
          ),
        );
      }
    }
  });
}

}

