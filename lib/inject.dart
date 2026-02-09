import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';


class InjectDependencies {
  static Future<bool> inject() async {
   
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
   // await Firebase.initializeApp();
    // if (kDebugMode) {
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    // } else {
    //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    // }
    // FlutterError.onError = (errorDetails) {
    //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    // };

    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(
    //     error,
    //     stack,
    //     fatal: true,
    //   );
    //   return true;
    // };
    // Get.put(
    //   AppUpdateService(),
    // );
    Get.put(
      SStorageService(),
    );
    Get.put(
      AuthService(
        Get.find<SStorageService>(),
      ),
    );
    
    Get.put(
      ApiService(),
    );

    Get.put(AppDatabase());
    Get.lazyPut<SubmissionDao>(
      () => SubmissionDao(Get.find<AppDatabase>()),
    );
    Get.lazyPut<ProjectDao>(
      () => ProjectDao(Get.find<AppDatabase>()),
    );

    Get.lazyPut<ProjectRepository>(
      () => ProjectRepository(Get.find<ProjectDao>()),
    );
    
    return await Future(
      () async => await Get.find<AuthService>().isLoggedIn(),
    );
  }
}