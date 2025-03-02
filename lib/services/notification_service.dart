import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'focus_channel',
          'Focus Reminders',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );
    await _notificationsPlugin.show(1, title, body, details);
  }

  static Future<void> scheduleDailyReminder() async {
    await _notificationsPlugin.zonedSchedule(
      2,
      '📌 Focus Reminder!',
      'It\'s time for your focus session. 🚀 Get ready to achieve!',
      _nextInstanceOfFocusTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails('focus_channel', 'Focus Reminders'),
      ),

      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  static tz.TZDateTime _nextInstanceOfFocusTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    ); // 9 صباحًا
    return scheduledTime.isBefore(now)
        ? scheduledTime.add(Duration(days: 1))
        : scheduledTime;
  }

  // جدولة إشعار معين بوقت محدد
  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_timer_channel',
          'Focus Timer',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),

      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }

  // جدولة إشعار انتهاء الجلسة بعد 5 دقائق
  static Future<void> scheduleEndSessionNotification(
    int id,
    String title,
    String body,
    DateTime endTime,
  ) async {
    DateTime notificationTime = endTime.add(Duration(minutes: 5)); // +5 دقائق
    await scheduleNotification(id, title, body, notificationTime);
  }

  // إلغاء جميع الإشعارات
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
