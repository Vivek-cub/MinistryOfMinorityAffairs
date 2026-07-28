import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ministry_of_minority_affairs/app/core/database/app_database.dart';
import 'package:ministry_of_minority_affairs/app/data/local/dao/submission_dao.dart';
import 'package:ministry_of_minority_affairs/app/data/repository/submission_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/data/repo/project_repository.dart';
import 'package:ministry_of_minority_affairs/app/modules/projectDetails/projectDb/project_dao.dart';
import 'package:ministry_of_minority_affairs/app/services/api_service.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_initializer.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_notification_service.dart';
import 'package:ministry_of_minority_affairs/app/services/sim_change_service.dart';
import 'package:ministry_of_minority_affairs/app/services/storage/s_storage_service.dart';
import 'package:timezone/data/latest.dart' as tz;

class InjectDependencies {
  static Future<bool> inject() async {
    tz.initializeTimeZones();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await FirebaseInitializer.initialize();
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    Get.put(SStorageService());
    Get.put(AuthService(Get.find<SStorageService>()));

    Get.put(SimChangeService(Get.find<SStorageService>()));

    Get.put(ApiService());

    Get.put(AppDatabase());
    Get.lazyPut<SubmissionDao>(() => SubmissionDao(Get.find<AppDatabase>()));
    Get.lazyPut<SubmissionRepository>(
      () => SubmissionRepository(Get.find<SubmissionDao>()),
    );
    Get.lazyPut<ProjectDao>(() => ProjectDao(Get.find<AppDatabase>()));

    Get.lazyPut<ProjectRepository>(
      () => ProjectRepository(Get.find<ProjectDao>()),
    );
    Get.put(FirebaseNotificationService(), permanent: true);

    // await Get.find<FirebaseNotificationService>().initialize();

    return await Future(() async => await Get.find<AuthService>().isLoggedIn());
  }
}
