// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
  }

  Future<void> showNotification(String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'cortex_channel',
      'C.O.R.T.E.X. Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    var details = NotificationDetails(android: androidDetails);
    await _plugin.show(0, title, body, details);
  }
}
