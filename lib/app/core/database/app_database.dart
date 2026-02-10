

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submissions.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_audio.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_images.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_remarks.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_video.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_milestone_attachments.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/local_projects.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Submissions,
    SubmissionImages,
    SubmissionAudio,
    SubmissionVideo,
    SubmissionRemarks,
    LocalProjects,
    LocalMilestones,
    LocalMilestoneAttachments
  ],
  daos: [
    SubmissionDao,
    ProjectDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase instance = AppDatabase._internal();
  factory AppDatabase() => instance;

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
        if (from < 7) {
          await m.addColumn(localProjects, localProjects.projectUniqueId);
        }
      },
      );
}


LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/app.db');
    return NativeDatabase(file);
  });

  
}
