import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/services/auth_service.dart';
import 'package:open_filex/open_filex.dart';

class FirebaseNotificationService extends GetxService {
  String? fcmToken;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    await _requestPermission();
    await _initializeLocalNotifications();
    await _configureListeners();

    fcmToken = await getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      fcmToken = token;
      debugPrint("New FCM Token: $token");
    });
  }

  static int badgeCount = 0;

  static void handleNotificationData(Map<String, dynamic> data) async {
    debugPrint(data.toString());
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          debugPrint("Payload: ${response.payload}");
        }
        _onNotificationTap(response);
      },
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.high,
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _configureListeners() async {
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await FlutterNewBadger.removeBadge();
      handleNotificationData(message.data);
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await FlutterNewBadger.removeBadge();
      handleNotificationData(initialMessage.data);
    }
  }

  // Future<void> getToken() async {
  //   final token = await FirebaseMessaging.instance.getToken();
  //   debugPrint("FCM Token: $token");

  //   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  //     debugPrint("New FCM Token: $newToken");
  //   });
  //   //await AuthService().setFcmToken(token);
  // }

  Future<String> getToken() async {
    try {
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        debugPrint("APNS Token: $apnsToken");

        if (apnsToken == null) {
          debugPrint("APNS token not available. Continuing without FCM.");
          return "";
        }
      }

      final token = await FirebaseMessaging.instance.getToken();
      debugPrint("FCM Token: $token");
      return token ?? "";
    } catch (e, s) {
      debugPrint("Unable to get FCM token: $e");
      debugPrintStack(stackTrace: s);

      return "";
    }
  }

  void _onForegroundMessage(RemoteMessage message) async {
    debugPrint(message.notification?.title);
    await FlutterNewBadger.incrementBadgeCount();

    // Show local notification
    await _showNotification(message);
  }

  Future<void> _updateBadge() async {}

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'Used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      badgeNumber: 1,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );
  }

  Future<void> showDownloadProgress({
    required int notificationId,
    required String fileName,
    required int progress,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'file_download_channel',
      'File Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: 100,
      channelShowBadge: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: notificationId,
      title: 'Downloading',
      body: fileName,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> showDownloadComplete({
    required int notificationId,
    required String fileName,
    required String filePath,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'file_download_channel',
      'File Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      channelShowBadge: false,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    debugPrint("========== SHOW DOWNLOAD COMPLETE ==========");
    debugPrint("fileName: $fileName");
    debugPrint("filePath: $filePath");
    debugPrint("============================================");
    await _localNotifications.show(
      id: notificationId,
      title: 'Download Complete',
      body: fileName,
      notificationDetails: notificationDetails,
      payload: filePath,
    );
  }

  Future<void> showDownloadFailed({
    required int notificationId,
    required String fileName,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'file_download_channel',
      'File Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: notificationId,
      title: 'Download Failed',
      body: 'Unable to download $fileName',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> _onNotificationTap(NotificationResponse response) async {
    final filePath = response.payload;
    debugPrint("========== NOTIFICATION TAP ==========");
    debugPrint("Payload: $filePath");
    debugPrint("======================================");

    if (filePath == null || filePath.isEmpty) {
      return;
    }

    try {
      final result = await OpenFilex.open(filePath);
      debugPrint("OpenFile result type: ${result.type}");
      debugPrint("OpenFile result message: ${result.message}");
    } catch (e, stackTrace) {
      debugPrint('Failed to open downloaded file: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
