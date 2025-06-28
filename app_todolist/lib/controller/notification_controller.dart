import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  final notificationPlugin= FlutterLocalNotificationsPlugin();


  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationPlugin.initialize(
      initializationSettings);
  }

  NotificationDetails getNotificationDetails() {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body}) async {
    if (!_isInitialized) {
      await initialize();
    }

    await notificationPlugin.show(
      id,
      title,
      body,
      getNotificationDetails(),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    var tzScheduledTime = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      3,
      00, // Set the time to 05:00 AM
    );

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledTime,
      
      getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) {
      await initialize();
    }

    await notificationPlugin.cancel(id);
  }
}
