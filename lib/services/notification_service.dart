import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static Future<void> scheduleDailyReminder() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Focus Reminder!'.tr(),
      "It's time for your focus session. 🚀 Get ready to achieve!".tr(),
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
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    ); // 9 صباحًا
    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }

  // إلغاء جميع الإشعارات
  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
