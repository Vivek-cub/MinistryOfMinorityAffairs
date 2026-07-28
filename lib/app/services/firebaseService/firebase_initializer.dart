import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:ministry_of_minority_affairs/app/services/firebaseService/firebase_notification_service.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(
      FirebaseInitializer.firebaseMessagingBackgroundHandler,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();

    debugPrint("Background Message: ${message.messageId}");

    FirebaseNotificationService.handleNotificationData(message.data);
    await FlutterNewBadger.incrementBadgeCount();
  }
}
