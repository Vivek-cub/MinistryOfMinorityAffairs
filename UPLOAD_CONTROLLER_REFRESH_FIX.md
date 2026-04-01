Target file:
`lib/app/modules/projectDetails/controller/upload_project_details_controller.dart`

Problem:
After submit, the app goes back to home, but home can still hold the old `HomeController` state in memory. When you open `WorkDetailView` again, it receives the old `project` object from home, so old milestone data is shown until full app restart.

Why app restart fixes it:
On restart, `HomeController` is created again and fetches fresh project data. That is why the latest data appears only after closing and reopening the app.

Important:
Do not delete `HomeController` before navigation. That causes this error while `HomeView` is still mounted:

```dart
"HomeController" not found. You need to call "Get.put(HomeController())" or "Get.lazyPut(()=>HomeController())"
```

That happens because `HomeView` is a `GetView<HomeController>` and still tries to read `controller` during rebuild.

Change needed in this one file:

1. Add this import:

```dart
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';
```

2. Add this helper method inside `UploadProjectDetailsController`:

```dart
void _refreshHomeIfAvailable() {
  if (Get.isRegistered<HomeController>()) {
    final homeController = Get.find<HomeController>();
    homeController.checkInternet();
  }
}
```

3. Replace the navigation inside `saveOffline()`

Current:

```dart
Get.back(result: true);
Get.toNamed(AppRoutes.home);
```

Replace with:

```dart
_refreshHomeIfAvailable();
Get.back(result: true);
Get.toNamed(AppRoutes.home);
```

4. Replace the success navigation inside `submitOnline()`

Current:

```dart
onPressed: () {
  Get.offAllNamed(AppRoutes.home);
},
```

Replace with:

```dart
onPressed: () async {
  _refreshHomeIfAvailable();
  Get.offAllNamed(AppRoutes.home);
},
```

Result:
- Existing `HomeController` stays alive, so `HomeView` does not crash.
- `HomeController.checkInternet()` runs again and refreshes dashboard/project data.
- When you open `WorkDetailView` again from homepage, it gets updated project data instead of stale data.

Exact updated shape for the relevant part:

```dart
import 'package:ministry_of_minority_affairs/app/modules/home/controllers/home_controller.dart';

class UploadProjectDetailsController extends GetxController
    with SnackBarMixin, PopupMixin {
  ...

  void _refreshHomeIfAvailable() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
      homeController.checkInternet();
    }
  }

  Future<void> saveOffline({bool showMessage = true}) async {
    ...

    if (showMessage) {
      Get.snackbar(
        'Saved Offline',
        'No internet. Data will sync automatically',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    _refreshHomeIfAvailable();
    Get.back(result: true);
    Get.toNamed(AppRoutes.home);
  }

  void submitOnline() async {
    try {
      showAlertCustom(backBtnDisable: true, title: "Uploading...");
      final modelData = await repo.uploadMilestoneFiles(
        ...
      );

      if (modelData.statusCode == '200') {
        Get.back();
        showSuccessDialog(
          Get.context!,
          message: "Your data is submitted successfully",
          onPressed: () async {
            _refreshHomeIfAvailable();
            Get.offAllNamed(AppRoutes.home);
          },
        );
      } else {
        ...
      }
    } catch (e) {
      Get.back();
    } finally {}
  }
}
```

Note:
This is the safer one-file fix. It keeps `HomeController` alive and refreshes it instead of deleting it.

---

SQLite error you saw:

```text
UNIQUE constraint failed: local_projects.user_id, local_projects.project_id
```

Why this happens:

- In [local_projects.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/projectDetails/projectDb/local_projects.dart), the real unique key is `(userId, projectId)`.
- In [project_dao.dart](/Users/sagaradhikari/Desktop/app/ministry/MinistryOfMinorityAffairs/lib/app/modules/projectDetails/projectDb/project_dao.dart#L20), `insertOnConflictUpdate()` is generating SQL based on the table primary key, which is `id`.
- So SQLite tries to insert a new row.
- That new row collides with the existing `(user_id, project_id)` unique key.
- Result: `code 2067` unique-constraint failure.

Relevant code involved:

Table unique key:

```dart
@override
List<Set<Column>> get uniqueKeys => [
  {userId, projectId},
];
```

Current DAO write:

```dart
await into(localProjects).insertOnConflictUpdate(
  LocalProjectsCompanion(
    userId: Value(userId),
    projectId: Value(project.id ?? ""),
    ...
  ),
);
```

What needs to be changed:

This is not an `UploadProjectDetailsController` problem. The actual fix belongs in:

`lib/app/modules/projectDetails/projectDb/project_dao.dart`

The insert must use the `(userId, projectId)` unique key as the conflict target, or do:

1. update by `userId + projectId` if row exists
2. insert only if it does not exist

Because you asked not to change code, I am only documenting it here.

Important conclusion:

- The home refresh fix in `upload_project_details_controller.dart` is still valid for stale UI data.
- The SQLite crash is a separate issue in `project_dao.dart`.
- If `saveToLocalDb()` runs again for the same project/user pair, this DAO conflict can happen until the DAO save logic is corrected.
