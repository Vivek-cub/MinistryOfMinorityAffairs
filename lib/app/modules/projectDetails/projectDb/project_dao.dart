import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone_attachments.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_projects.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_db_helper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

part 'project_dao.g.dart';

@DriftAccessor(tables: [
  LocalProjects,
  LocalMilestones,
  LocalMilestoneAttachments,
])
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
          address: Value(project.address ?? ""),
          createdAt: Value(project.createdAt??DateTime.now()),
          districtId: Value(project.districtId ?? ""),
          projectUniqueId: Value(project.projectUniqueId ?? ""),
        ),
      );

      await (delete(localMilestones)
            ..where((m) => m.projectId.equals(project.id ?? "")))
          .go();

      await (delete(localMilestoneAttachments)
            ..where((a) => a.projectId.equals(project.id ?? "")))
          .go();

      for (final m in project.milestones ?? []) {
        await into(localMilestones).insert(
          LocalMilestonesCompanion(
            milestoneId: Value(m.id ?? ""),
            projectId: Value(project.id ?? ""),
            name: Value(m.milestoneName ?? ""),
            description: Value(m.milestoneDescription ?? ""),
            status: Value(m.status ?? ""),
          ),
        );

        for (final img in m.imageAtt ?? []) {
          await into(localMilestoneAttachments).insert(
            LocalMilestoneAttachmentsCompanion(
              projectId: Value(project.id ?? ""),
              milestoneId: Value(m.id ?? ""),
              type: const Value('image'),
              filePath: Value(img),
            ),
          );
        }

        if (m.audioAtt?.isNotEmpty == true) {
          await into(localMilestoneAttachments).insert(
            LocalMilestoneAttachmentsCompanion(
              projectId: Value(project.id ?? ""),
              milestoneId: Value(m.id ?? ""),
              type: const Value('audio'),
              filePath: Value(m.audioAtt!),
            ),
          );
        }

        if (m.videoAtt?.isNotEmpty == true) {
          await into(localMilestoneAttachments).insert(
            LocalMilestoneAttachmentsCompanion(
              projectId: Value(project.id ?? ""),
              milestoneId: Value(m.id ?? ""),
              type: const Value('video'),
              filePath: Value(m.videoAtt!),
            ),
          );
        }
      }
    });
  }

  Future<List<LocalProjectFull>> getAllProjectsFull() async {
    final projects = await select(localProjects).get();
    final result = <LocalProjectFull>[];

    for (final p in projects) {
      final milestones = await (select(localMilestones)
            ..where((m) => m.projectId.equals(p.projectId)))
          .get();

      final milestoneFullList = <LocalMilestoneFull>[];

      for (final m in milestones) {
        final attachments = await (select(localMilestoneAttachments)
              ..where((a) =>
                  a.projectId.equals(p.projectId) &
                  a.milestoneId.equals(m.milestoneId)))
            .get();

        milestoneFullList.add(
          LocalMilestoneFull(
            milestone: m,
            images: attachments
                .where((a) => a.type == 'image')
                .map((a) => a.filePath)
                .toList(),
            audio: attachments
                .where((a) => a.type == 'audio')
                .map((a) => a.filePath)
                .firstOrNull,
            video: attachments
                .where((a) => a.type == 'video')
                .map((a) => a.filePath)
                .firstOrNull,
          ),
        );
      }

      result.add(
        LocalProjectFull(
          project: p,
          milestones: milestoneFullList,
        ),
      );
    }

    return result;
  }
}
