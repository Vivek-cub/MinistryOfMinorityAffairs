# Offline DB Fix Guide

This file does not change your app. It shows the exact places where you should update code to make the offline DB flow correct and duplicate-safe.

## Goal

You asked for these behaviors:

1. `Update Progress` opens `WorkDetailView` and saves project locally.
2. If there is no internet, show saved project list from local DB.
3. No duplicate project.
4. Clicking a milestone in `WorkDetailView` opens `UploadProjectDetails`.
5. On submit, check internet.
6. If no internet, save to local DB with no duplicate.
7. Offline revisit should show images, video, audio, progress percentage, and remarks.
8. Video capture should only show for the last milestone.
9. When user reaches home and internet is available, upload pending data to API.
10. No duplicity in local save or sync.

## Files To Change

### Database schema

- `lib/app/modules/projectDetails/projectDb/local_projects.dart`
- `lib/app/modules/projectDetails/projectDb/local_milestone.dart`
- `lib/app/modules/projectDetails/projectDb/local_milestone_attachments.dart`
- `lib/app/data/local/tables/submissions.dart`
- `lib/app/data/local/tables/submission_remarks.dart`
- `lib/app/core/database/app_database.dart`

### DAO / repository

- `lib/app/modules/projectDetails/projectDb/project_dao.dart`
- `lib/app/data/local/dao/submission_dao.dart`
- `lib/app/data/repository/submission_repository.dart`
- `lib/app/core/database/pending_submission.dart`
- `lib/app/modules/projectDetails/data/repo/project_repository.dart`

### Controllers / views

- `lib/app/modules/projectDetails/controller/work_detail_controller.dart`
- `lib/app/modules/projectDetails/controller/upload_project_details_controller.dart`
- `lib/app/modules/projectDetails/views/upload_project_details.dart`
- `lib/app/modules/projectDetails/widget/milestone_card.dart`
- `lib/app/modules/home/controllers/home_controller.dart`
- `lib/app/services/auth_service.dart`

## 1. Fix duplicate projects in local DB

### Change in `local_projects.dart`

Make `projectId` unique.

```dart
import 'package:drift/drift.dart';

class LocalProjects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text().unique()();
  TextColumn get projectName => text()();
  TextColumn get status => text()();
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get districtId => text().nullable()();
  TextColumn get projectUniqueId => text()();
}
```

### Change in `local_milestone.dart`

Make one milestone unique inside one project.

```dart
import 'package:drift/drift.dart';

class LocalMilestones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get milestoneId => text()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get status => text()();
  IntColumn get progress => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {projectId, milestoneId},
  ];
}
```

### Change in `local_milestone_attachments.dart`

Prevent duplicate attachments.

```dart
import 'package:drift/drift.dart';

class LocalMilestoneAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get milestoneId => text()();
  TextColumn get type => text()();
  TextColumn get filePath => text()();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {projectId, milestoneId, type, filePath},
  ];
}
```

## 2. Fix pending submission duplicates

### Change in `submissions.dart`

Use one draft per `projectId + milestoneId`.

```dart
import 'package:drift/drift.dart';

class Submissions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get projectId => text()();
  TextColumn get milestoneId => text()();
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  TextColumn get userLat => text()();
  TextColumn get userLng => text()();
  TextColumn get progress => text()();
  TextColumn get projectStatus => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {projectId, milestoneId},
  ];
}
```

## 3. Add remarks to pending submission model

### Change in `pending_submission.dart`

```dart
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_audio.dart';
import 'package:ministry_of_minority_affairs/app/data/local/tables/submission_video.dart';

class PendingSubmission {
  final Submission submission;
  final List<SubmissionImage> images;
  final SubmissionAudioData? audio;
  final SubmissionVideoData? video;
  final SubmissionRemark? remark;

  PendingSubmission({
    required this.submission,
    required this.images,
    this.audio,
    this.video,
    this.remark,
  });
}
```

## 4. Replace always-insert submission logic with upsert/update

### Change in `submission_dao.dart`

Current issue:
- It always inserts a new submission.
- It never reads remarks back.
- It marks synced by `projectId`, which is wrong.

Use this approach:

```dart
Future<void> saveSubmission({
  required String projectId,
  required String milestoneId,
  required List<String> images,
  String? audioPath,
  int? audioDuration,
  String? videoPath,
  int? videoDuration,
  required String remarks,
  bool isSynced = false,
  String? userLat,
  String? userLng,
  String? progress,
  String? projectStatus,
}) async {
  await transaction(() async {
    final existing = await (select(submissions)
          ..where((t) =>
              t.projectId.equals(projectId) &
              t.milestoneId.equals(milestoneId)))
        .getSingleOrNull();

    int submissionId;

    if (existing == null) {
      submissionId = await into(submissions).insert(
        SubmissionsCompanion.insert(
          projectId: projectId,
          milestoneId: milestoneId,
          isSynced: Value(isSynced),
          userLat: userLat ?? "",
          userLng: userLng ?? "",
          progress: progress ?? "",
          projectStatus: projectStatus ?? "",
        ),
      );
    } else {
      submissionId = existing.id;

      await (update(submissions)..where((t) => t.id.equals(submissionId))).write(
        SubmissionsCompanion(
          isSynced: Value(isSynced),
          userLat: Value(userLat ?? ""),
          userLng: Value(userLng ?? ""),
          progress: Value(progress ?? ""),
          projectStatus: Value(projectStatus ?? ""),
        ),
      );

      await (delete(submissionImages)
            ..where((t) => t.submissionId.equals(submissionId)))
          .go();
      await (delete(submissionAudio)
            ..where((t) => t.submissionId.equals(submissionId)))
          .go();
      await (delete(submissionVideo)
            ..where((t) => t.submissionId.equals(submissionId)))
          .go();
      await (delete(submissionRemarks)
            ..where((t) => t.submissionId.equals(submissionId)))
          .go();
    }

    await into(submissionRemarks).insert(
      SubmissionRemarksCompanion(
        submissionId: Value(submissionId),
        remarks: Value(remarks),
      ),
    );

    for (final img in images.toSet()) {
      await into(submissionImages).insert(
        SubmissionImagesCompanion(
          submissionId: Value(submissionId),
          filePath: Value(img),
        ),
      );
    }

    if (audioPath != null && audioPath.isNotEmpty) {
      await into(submissionAudio).insertOnConflictUpdate(
        SubmissionAudioCompanion(
          submissionId: Value(submissionId),
          filePath: Value(audioPath),
          durationMs: Value(audioDuration ?? 0),
        ),
      );
    }

    if (videoPath != null && videoPath.isNotEmpty) {
      await into(submissionVideo).insertOnConflictUpdate(
        SubmissionVideoCompanion(
          submissionId: Value(submissionId),
          filePath: Value(videoPath),
          durationMs: Value(videoDuration),
        ),
      );
    }
  });
}
```

### Also replace `getPendingSubmissions()`

```dart
Future<List<PendingSubmission>> getPendingSubmissions() async {
  final pending = await (select(submissions)
        ..where((tbl) => tbl.isSynced.equals(false)))
      .get();

  final result = <PendingSubmission>[];

  for (final sub in pending) {
    final images = await (select(submissionImages)
          ..where((t) => t.submissionId.equals(sub.id)))
        .get();

    final audio = await (select(submissionAudio)
          ..where((t) => t.submissionId.equals(sub.id)))
        .getSingleOrNull();

    final video = await (select(submissionVideo)
          ..where((t) => t.submissionId.equals(sub.id)))
        .getSingleOrNull();

    final remark = await (select(submissionRemarks)
          ..where((t) => t.submissionId.equals(sub.id)))
        .getSingleOrNull();

    result.add(
      PendingSubmission(
        submission: sub,
        images: images,
        audio: audio,
        video: video,
        remark: remark,
      ),
    );
  }

  return result;
}
```

### Replace `markAsSynced(String projectId)`

Use submission id.

```dart
Future<void> markAsSynced(int submissionId) {
  return (update(submissions)..where((t) => t.id.equals(submissionId))).write(
    const SubmissionsCompanion(
      isSynced: Value(true),
    ),
  );
}
```

## 5. Update repository method signatures

### Change in `submission_repository.dart`

```dart
Future<void> markAsSynced(int submissionId) {
  return dao.markAsSynced(submissionId);
}
```

## 6. Fix sync on home screen

### Change in `home_controller.dart`

Remove `_uniqueByProjectId`.
Upload every pending submission separately.
Pass the correct `projectStatus`.
Mark only uploaded submission synced.

Replace `syncPendingSubmissions()` with:

```dart
Future<void> syncPendingSubmissions() async {
  final hasInternet = await NetworkService.hasInternet();
  if (!hasInternet) return;

  final pendingList = await submissionRepo.getPending();
  if (pendingList.isEmpty) return;

  for (final item in pendingList) {
    try {
      final response = await projectRepo.uploadMilestoneFiles(
        projectId: item.submission.projectId,
        milestoneId: item.submission.milestoneId,
        imagePaths: item.images.map((e) => e.filePath).toList(),
        audioPath: item.audio?.filePath,
        videoPath: item.video?.filePath,
        userLat: item.submission.userLat,
        userLng: item.submission.userLng,
        progress: item.submission.progress,
        projectStatus: item.submission.projectStatus,
        remarks: item.remark?.remarks ?? "",
      );

      if (response.statusCode == '200') {
        await submissionRepo.markAsSynced(item.submission.id);
      }
    } catch (_) {}
  }
}
```

Delete this helper:

```dart
List<PendingSubmission> _uniqueByProjectId(List<PendingSubmission> list)
```

It is causing skipped uploads.

## 7. Add remarks support in upload API call

### Change in `project_detail_repo.dart`

```dart
abstract class ProjectDetailRepo {
  Future<CommonResponseModel> uploadMilestoneFiles({
    required String projectId,
    required String milestoneId,
    required List<String> imagePaths,
    String? videoPath,
    String? audioPath,
    required String userLat,
    required String userLng,
    required String progress,
    required String projectStatus,
    String? remarks,
  });
}
```

### Change in `project_detail_repo_impl.dart`

Add `remarks` to method signature and form data:

```dart
formData.fields.addAll([
  MapEntry('projectId', projectId),
  MapEntry('milestoneId', milestoneId),
  MapEntry('lat', userLat),
  MapEntry('lng', userLng),
  MapEntry('progress', progress),
  MapEntry('projectStatus', projectStatus),
  MapEntry('remarks', remarks ?? ""),
]);
```

If the API does not support remarks, then do not save remarks as "fully syncable" data. But your current requirement says it should be visible offline, so you should still keep it locally.

## 8. Rehydrate offline draft into Upload screen

### Add a DAO helper in `submission_dao.dart`

Create one method:

```dart
Future<PendingSubmission?> getDraftByProjectAndMilestone({
  required String projectId,
  required String milestoneId,
}) async {
  final sub = await (select(submissions)
        ..where((t) =>
            t.projectId.equals(projectId) &
            t.milestoneId.equals(milestoneId) &
            t.isSynced.equals(false)))
      .getSingleOrNull();

  if (sub == null) return null;

  final images = await (select(submissionImages)
        ..where((t) => t.submissionId.equals(sub.id)))
      .get();

  final audio = await (select(submissionAudio)
        ..where((t) => t.submissionId.equals(sub.id)))
      .getSingleOrNull();

  final video = await (select(submissionVideo)
        ..where((t) => t.submissionId.equals(sub.id)))
      .getSingleOrNull();

  final remark = await (select(submissionRemarks)
        ..where((t) => t.submissionId.equals(sub.id)))
      .getSingleOrNull();

  return PendingSubmission(
    submission: sub,
    images: images,
    audio: audio,
    video: video,
    remark: remark,
  );
}
```

### Add repository wrapper in `submission_repository.dart`

```dart
Future<PendingSubmission?> getDraftByProjectAndMilestone({
  required String projectId,
  required String milestoneId,
}) {
  return dao.getDraftByProjectAndMilestone(
    projectId: projectId,
    milestoneId: milestoneId,
  );
}
```

### In `upload_project_details_controller.dart`

In `_initializeProjectData()`, after reading args:

```dart
Future<void> _initializeProjectData() async {
  final args = Get.arguments;
  if (args is Map<String, dynamic>) {
    data.value = args['project'] ?? ProjectDetails();
    selectedMilestoneId.value = args["milestoneId"] ?? "";
  }

  await _loadOfflineDraftIfExists();
}
```

Then add:

```dart
Future<void> _loadOfflineDraftIfExists() async {
  final projectId = data.value.id ?? '';
  final milestoneId = selectedMilestoneId.value;

  if (projectId.isEmpty || milestoneId.isEmpty) return;

  final draft = await repository.getDraftByProjectAndMilestone(
    projectId: projectId,
    milestoneId: milestoneId,
  );

  if (draft == null) return;

  final imagePaths = draft.images.map((e) => e.filePath).toList();
  for (int i = 0; i < imagePaths.length && i < photos.length; i++) {
    photos[i] = imagePaths[i];
  }

  audioPath = draft.audio?.filePath ?? "";
  videoPath.value = draft.video?.filePath ?? "";
  finalVideoPath = draft.video?.filePath ?? "";
  remarksController.text = draft.remark?.remarks ?? "";
  selectedProgress.value = draft.submission.projectStatus;
  statusProgressValue.value =
      int.tryParse(draft.submission.progress) ?? 0;
}
```

This is the key fix for your point 7.

## 9. Save media in permanent storage, not temp

### Problem

Your current code stores compressed files in temporary directory. The OS may delete them.

### Where to change

- `work_detail_controller.dart`
- `upload_project_details_controller.dart`

### What to do

Create a helper:

```dart
Future<Directory> _offlineMediaDir() async {
  final dir = await getApplicationDocumentsDirectory();
  final mediaDir = Directory('${dir.path}/offline_media');
  if (!await mediaDir.exists()) {
    await mediaDir.create(recursive: true);
  }
  return mediaDir;
}
```

Then replace `getTemporaryDirectory()` usage with `_offlineMediaDir()`.

Use this for:

- compressed images
- compressed audio
- compressed video

## 10. Show video only for last milestone

### In `upload_project_details_controller.dart`

Add:

```dart
bool get isLastPendingMilestone {
  final milestones = data.value.milestones ?? [];
  final incomplete = milestones.where((m) => m.status != "Completed").toList();
  if (incomplete.isEmpty) return false;
  return incomplete.last.id == selectedMilestoneId.value;
}
```

### In `upload_project_details.dart`

Wrap the Video section:

```dart
Obx(() {
  if (!controller.isLastPendingMilestone) {
    return const SizedBox.shrink();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const TitleText(
        text: 'Video',
        fontWeight: FontWeight.w600,
      ),
      const SizedBox(height: AppDimensions.sm),
      CapturedVideoPreview(
        videoPath: controller.videoPath.value,
        onCaptureTap: controller.onCaptureVideo,
        onRemoveTap: () {
          controller.videoPath.value = "";
        },
      ),
      const SizedBox(height: AppDimensions.lg),
    ],
  );
})
```

### In submit validation

Replace:

```dart
if(finalVideoPath == ""){
  ...
}
```

With:

```dart
if (isLastPendingMilestone && (finalVideoPath == null || finalVideoPath!.isEmpty)) {
  showErrorDialog(
    Get.context!,
    message: "Please Upload Video",
  );
  return;
}
```

## 11. Render local images properly

### Change in `milestone_card.dart`

Current code always uses `Image.network`.
Use local file rendering for local paths:

```dart
import 'dart:io';
```

Then:

```dart
Widget _buildImage(String path) {
  final isRemote = path.startsWith('http://') || path.startsWith('https://');

  return ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: isRemote
        ? Image.network(
            path,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(path),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
  );
}
```

Use `_buildImage(milestone.imageAtt![i])` in the list.

## 12. Why user-wise local DB matters

### The problem

Right now your local DB is app-level, not user-level.

That means:

- User A logs in and saves offline data.
- User A logs out.
- User B logs in on the same device.
- User B may still see User A's offline cached projects or pending submissions.

That is what I meant by "scope local DB by user".

### Option A: Better approach

Store `userId` in local tables.

That means adding `userId` to tables such as:

- `LocalProjects`
- `LocalMilestones`
- `LocalMilestoneAttachments`
- `Submissions`

Then:

- when saving, save with the current logged-in `userId`
- when reading, read only rows of that `userId`

So each user's offline data stays separate.

### Option B: Easier approach

If you do not want to add `userId` in all tables, then clear local DB on logout.

That means:

- whenever user logs out
- delete all offline cached projects
- delete all pending submissions

This is easier than user-wise filtering, but it removes offline data completely after logout.

### Which one should you choose?

- Use `userId` columns if the same device may be used by multiple officers.
- Use "clear on logout" if only one user normally uses the device and you want simpler code.

### Example clear method

This example is only for understanding:

```dart
Future<void> clearAllLocalData() async {
  await transaction(() async {
    await delete(submissionImages).go();
    await delete(submissionAudio).go();
    await delete(submissionVideo).go();
    await delete(submissionRemarks).go();
    await delete(submissions).go();
    await delete(localMilestoneAttachments).go();
    await delete(localMilestones).go();
    await delete(localProjects).go();
  });
}
```

Then call that from logout if you choose the simpler approach.

### Files related to this part

- `lib/app/services/auth_service.dart`
- DAO files where local tables are read/written

## 12A. You added `userId` - now how to use it

If you already added `userId` in local tables, that is only step 1.

You must now use it in 3 places:

1. while saving data
2. while reading data
3. while syncing or clearing data

### Rule to follow

Every local DB operation should work only for the current logged-in user.

That means:

- save with `userId`
- query with `userId`
- update with `userId`
- delete with `userId`

If you add the column but do not use it in queries, it gives no real protection.

### Step 1: Get current user id

You already have:

```dart
Future<String?> getUserId() async =>
    storage.readKey(key: SStorageKeys.userId);
```

So everywhere you save/read local DB data, first get the current user id.

Example idea:

```dart
final userId = await authService.getUserId();
if (userId == null || userId.isEmpty) return;
```

### Step 2: Use `userId` while saving project cache

When opening `WorkDetailView`, project cache is saved.

That save method should include:

- `projectId`
- project fields
- `userId`

So in `saveProject(...)`, insert/update should save:

```dart
userId: Value(userId),
```

And if milestones and attachments also have `userId`, save it there too.

### Step 3: Use `userId` while saving offline submission

When user submits without internet, offline draft is saved.

That save should include:

- `projectId`
- `milestoneId`
- `userId`
- media
- remarks
- progress

So the row belongs to one user only.

### Step 4: Use `userId` when checking existing draft

If you are preventing duplicates, do not check only:

```dart
projectId + milestoneId
```

Check:

```dart
projectId + milestoneId + userId
```

Because two different users on one device should not update each other's draft.

Example condition idea:

```dart
..where((t) =>
    t.projectId.equals(projectId) &
    t.milestoneId.equals(milestoneId) &
    t.userId.equals(userId))
```

### Step 5: Use `userId` when loading offline project list

When loading cached projects from DB, read only current user's data.

Do not load all rows from local tables.

Use:

```dart
where project.userId == currentUserId
```

Otherwise offline project list may show projects saved by another user.

### Step 6: Use `userId` when loading draft into upload screen

When reopening `UploadProjectDetails` offline, the query for draft must be:

- same `projectId`
- same `milestoneId`
- same `userId`
- not synced

That way the correct user's draft is restored.

### Step 7: Use `userId` during sync

When home screen syncs pending submissions, fetch only:

- current user's unsynced submissions

Do not sync all pending rows from the entire app DB.

So pending query should filter by:

- `isSynced = false`
- `userId = currentUserId`

### Step 8: Use `userId` when marking as synced

Best practice:

- mark by `submissionId`

If you also want extra safety, update by:

- `submissionId`
- `userId`

That prevents one user from changing another user's submission row.

### Step 9: Use `userId` on logout

You have 2 possible behaviors:

#### Option A: Keep data user-wise

On logout, do nothing to DB.

Then when next user logs in:

- app loads only rows matching that new user's `userId`

Old user's rows stay in DB but remain invisible to the new user.

This is the main benefit of adding `userId`.

#### Option B: Clear only current user's local data

On logout, delete only rows where:

```dart
userId == currentUserId
```

This is useful if you do not want offline data to remain on device after logout.

### Step 10: Unique keys should include `userId`

If the same device supports multiple users, unique constraints should normally include `userId`.

Examples:

For project cache:

```dart
{userId, projectId}
```

For milestones:

```dart
{userId, projectId, milestoneId}
```

For pending submissions:

```dart
{userId, projectId, milestoneId}
```

This is better than using only `projectId` or `projectId + milestoneId`.

### Short example of how to think

Without `userId`:

- Project `P1` draft of milestone `M1`

With `userId`:

- User A + Project `P1` + Milestone `M1`
- User B + Project `P1` + Milestone `M1`

These must be treated as different local records.

### In simple words

Adding `userId` column is not enough.

You must use it in:

- insert
- update
- select
- delete
- sync filters
- unique keys

That is the full meaning of "user-wise local DB".

## 13. What "database migration" means here

### Simple meaning

Your app already has an old DB on users' phones.

If you change table structure now, for example:

- add unique constraints
- add `userId`
- change keys

then the app must know how to move from old DB structure to new DB structure safely.

That process is called migration.

### Why just changing the table file is not enough

Suppose old app already created:

- `submissions`
- `local_projects`

Now you add unique constraints in Dart code only.

Existing phones still already have the old SQLite tables.
Those old tables do not magically get new constraints unless migration is handled.

### Why I said to increase schema version

Drift checks `schemaVersion`.

If version changes from:

```dart
10
```

to:

```dart
11
```

then Drift knows:

"DB structure changed, so run upgrade logic."

### Why this is important in your case

You want to add:

- duplicate prevention
- maybe `userId`
- safer keys

These are table-structure changes, not small logic-only changes.

### Important note about unique constraints

For Drift/SQLite, adding a unique key later often needs table rebuild logic.

That usually means:

1. create a new table with the correct constraints
2. copy clean data from old table to new table
3. drop old table
4. rename new table

That is why I wrote:

"unique-key changes usually require table rebuild migration"

### In very simple words

- `schemaVersion` change tells Drift that DB changed
- migration code tells Drift how to safely update old DB

### Files related to this part

- `lib/app/core/database/app_database.dart`

## 14. Best order to apply changes

This section was only the safest working order, not a strict rule.

### Why order matters

If you change controller code first, but DB methods are still old, the app logic becomes mismatched.

So the safest order is:

### Step 1: Fix table definitions first

Change the structure of:

1. `submissions.dart`
2. `local_projects.dart`
3. `local_milestone.dart`
4. `local_milestone_attachments.dart`

Reason:
- these define how data is stored

### Step 2: Fix model/helper classes

Then update:

5. `pending_submission.dart`

Reason:
- this model must match the DB data you now want to read

### Step 3: Fix DAO and repository methods

Then update:

6. `submission_dao.dart`
7. `submission_repository.dart`
8. `project_detail_repo.dart`
9. `project_detail_repo_impl.dart`

Reason:
- these are the actual save/load/sync methods

### Step 4: Fix controller logic

Then update:

10. `home_controller.dart`
11. `upload_project_details_controller.dart`

Reason:
- these use repository/DAO methods
- by this point storage logic is already correct

### Step 5: Fix UI conditions

Then update:

12. `upload_project_details.dart`
13. `milestone_card.dart`

Reason:
- UI should be updated after backend logic is ready
- here you handle last milestone video visibility and local image rendering

### Step 6: Update DB version and logout behavior

Finally update:

14. `app_database.dart`
15. `auth_service.dart`

Reason:
- `app_database.dart` is where migration/versioning is finalized
- `auth_service.dart` is where logout cleanup logic can be connected

### Short version

The order is:

1. table structure
2. models
3. DAO/repository
4. controllers
5. UI
6. migration/logout cleanup

That is all section 14 meant.

## 15. Minimum final behavior after these fixes

After the above changes:

- Opening `WorkDetailView` can cache project safely.
- Offline project list can show cached projects without DB duplication.
- Offline submit updates the existing draft for the same milestone instead of creating duplicates.
- Offline reopen of the same milestone can show:
  - images
  - audio
  - video
  - remarks
  - progress percentage
  - project status
- Video appears only for the last milestone.
- Home sync uploads each pending milestone separately.
- Successful sync marks only that uploaded submission as synced.
- Local offline files survive app restarts because they are not stored in temp.

## Current project files you should inspect while applying this

- [upload_project_details_controller.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/projectDetails/controller/upload_project_details_controller.dart)
- [home_controller.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/home/controllers/home_controller.dart)
- [submission_dao.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/data/local/dao/submission_dao.dart)
- [project_dao.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/projectDetails/projectDb/project_dao.dart)
- [milestone_card.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/projectDetails/widget/milestone_card.dart)
