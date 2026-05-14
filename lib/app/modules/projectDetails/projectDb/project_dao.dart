import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone_attachments.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_projects.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_db_helper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/milestone_attachment_mapper.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectList/data/model/project_details.dart';

part 'project_dao.g.dart';

@DriftAccessor(
  tables: [LocalProjects, LocalMilestones, LocalMilestoneAttachments],
)
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(AppDatabase db) : super(db);

  Future<void> saveProject(ProjectDetails project, String userId) async {
    await transaction(() async {
      await into(localProjects).insertOnConflictUpdate(
        LocalProjectsCompanion(
          userId: Value(userId),
          projectId: Value(project.id ?? ""),
          projectName: Value(project.projectName ?? ""),
          status: Value(project.status ?? ""),
          lat: Value(project.lat),
          lng: Value(project.lng),
          address: Value(project.address ?? ""),
          createdAt: Value(project.createdAt ?? DateTime.now()),
          districtId: Value(project.districtId ?? ""),
          projectUniqueId: Value(project.projectUniqueId ?? ""),
        ),
      );

      await (delete(localMilestones)..where(
        (m) => m.userId.equals(userId) & m.projectId.equals(project.id ?? ""),
      )).go();

      await (delete(localMilestoneAttachments)..where(
        (a) => a.userId.equals(userId) & a.projectId.equals(project.id ?? ""),
      )).go();

      if (project.videoAtt?.isNotEmpty == true) {
        await into(localMilestoneAttachments).insert(
          LocalMilestoneAttachmentsCompanion(
            userId: Value(userId),
            projectId: Value(project.id ?? ""),
            milestoneId: const Value(""),
            type: const Value('video'),
            filePath: Value(project.videoAtt!),
          ),
        );
      }

      for (final m in project.milestones ?? []) {
        await into(localMilestones).insert(
          LocalMilestonesCompanion(
            userId: Value(userId),
            milestoneId: Value(m.id ?? ""),
            projectId: Value(project.id ?? ""),
            name: Value(m.milestoneName ?? ""),
            description: Value(m.milestoneDescription ?? ""),
            status: Value(m.status ?? ""),
            progress: Value(m.progress ?? 0),
          ),
        );

        for (final img in MilestoneAttachmentMapper.imagePaths(m)) {
          await into(localMilestoneAttachments).insert(
            LocalMilestoneAttachmentsCompanion(
              userId: Value(userId),
              projectId: Value(project.id ?? ""),
              milestoneId: Value(m.id ?? ""),
              type: const Value('image'),
              filePath: Value(img),
            ),
          );
        }
        for (final audio in MilestoneAttachmentMapper.audioPaths(m)) {
          await into(localMilestoneAttachments).insert(
            LocalMilestoneAttachmentsCompanion(
              userId: Value(userId),
              projectId: Value(project.id ?? ""),
              milestoneId: Value(m.id ?? ""),
              type: const Value('audio'),
              filePath: Value(audio),
            ),
          );
        }

        // if (m.audioAtt?.isNotEmpty == true) {
        //   await into(localMilestoneAttachments).insert(
        //     LocalMilestoneAttachmentsCompanion(
        //       userId: Value(userId),
        //       projectId: Value(project.id ?? ""),
        //       milestoneId: Value(m.id ?? ""),
        //       type: const Value('audio'),
        //       filePath: Value(m.audioAtt!),
        //     ),
        //   );
        // }

      }
    });
  }

  Future<List<LocalProjectFull>> getAllProjectsFull(String userId) async {
    final projects =
        await (select(localProjects)
          ..where((p) => p.userId.equals(userId))).get();
    final result = <LocalProjectFull>[];

    for (final p in projects) {
      final projectVideo =
          await (select(localMilestoneAttachments)..where(
            (a) =>
                a.userId.equals(userId) &
                a.projectId.equals(p.projectId) &
                a.milestoneId.equals("") &
                a.type.equals('video'),
          )).getSingleOrNull();

      final milestones =
          await (select(localMilestones)..where(
            (m) => m.userId.equals(userId) & m.projectId.equals(p.projectId),
          )).get();

      final milestoneFullList = <LocalMilestoneFull>[];

      for (final m in milestones) {
        final attachments =
            await (select(localMilestoneAttachments)..where(
              (a) =>
                  a.userId.equals(userId) &
                  a.projectId.equals(p.projectId) &
                  a.milestoneId.equals(m.milestoneId),
            )).get();

        milestoneFullList.add(
          LocalMilestoneFull(
            milestone: m,
            images:
                attachments
                    .where((a) => a.type == 'image')
                    .map((a) => a.filePath)
                    .toList(),
            audio:
                attachments
                    .where((a) => a.type == 'audio')
                    .map((a) => a.filePath)
                    .toList(),
            video:
                attachments
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
          video: projectVideo?.filePath,
        ),
      );
    }

    return result;
  }

  Future<void> clearLocalDataForUser(String userId) async {
    await transaction(() async {
      await (delete(localMilestoneAttachments)
        ..where((a) => a.userId.equals(userId))).go();
      await (delete(localMilestones)
        ..where((m) => m.userId.equals(userId))).go();
      await (delete(localProjects)..where((p) => p.userId.equals(userId))).go();
    });
  }
}
