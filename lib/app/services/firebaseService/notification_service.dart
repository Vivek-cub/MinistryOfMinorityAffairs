import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    String? token = await messaging.getToken();

    print("FCM Token : $token");
  }
}
