
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/core/network/token_storage.dart';
import 'package:ministry_of_minority_affairs/app/core/storage/secure_storage_token.dart';
import '../database/app_database.dart';
import '../../services/api_service.dart';
import 'package:flutter/material.dart';

class AppInitializer {
  AppInitializer._(); // no instance

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();


    // Database (global singleton)
    Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );

  //  local Storage
    Get.put<TokenStorage>(
      SecureTokenStorage(),
      permanent: true
    );

    // Services
   // await Get.putAsync(() => StorageService().init());
  //  await Get.putAsync(() => ApiService().init());

    // Orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // System UI
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
