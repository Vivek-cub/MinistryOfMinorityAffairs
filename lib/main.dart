import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/firebase_options.dart';
import 'package:ministry_of_minority_affairs/inject.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dotenv.load(
  //   fileName: ".env.prod",
  //   //  fileName: "assets/.env.dev",
  // );
  await InjectDependencies.inject();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "PMJVK Nigrani",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // GetX Navigation Configuration
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.rightToLeft,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () {
          // Redirect unknown routes to home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed(AppRoutes.splash);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),

      // Localization (can be extended later)
      locale: const Locale('en', 'IN'),
      fallbackLocale: const Locale('en', 'IN'),

      // Error handling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

class CrashlyticsRouteObserver extends NavigatorObserver {
  void _updateRoute(String? routeName, String? prevRoute) {
    if (routeName != null) {
      FirebaseCrashlytics.instance.setCustomKey('current_route', routeName);
    }
    if (prevRoute != null) {
      FirebaseCrashlytics.instance.setCustomKey('previous_route', prevRoute);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? prev) {
    _updateRoute(route.settings.name, prev?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateRoute(newRoute?.settings.name, oldRoute?.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? prev) {
    _updateRoute(prev?.settings.name, prev?.settings.name);
  }
}
