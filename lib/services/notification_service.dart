import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(InitializationSettings(android: androidSettings));

    await _notifications.periodicallyShow(
      0, '🍳 Рецепт на денот!', 'Провери нов рецепт!',
      RepeatInterval.daily,
      NotificationDetails(android: AndroidNotificationDetails('daily', 'Daily Recipe', importance: Importance.high)),
    );

    FirebaseMessaging.onMessage.listen((message) {
      _notifications.show(0, message.notification?.title, message.notification?.body,
          NotificationDetails(android: AndroidNotificationDetails('fcm', 'FCM')));
    });
  }
}
