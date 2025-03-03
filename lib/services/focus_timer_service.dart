import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FocusTimerService {
  static int remainingTime = 25 * 60; // الافتراضي 25 دقيقة
  static Timer? _timer;
  static bool isRunning = false;

  static Future<void> startTimer(int seconds) async {
    if (isRunning) return;
    isRunning = true;
    remainingTime = seconds; // تعيين المدة المختارة

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        remainingTime--;
        await showInteractiveNotification();
      } else {
        stopTimer();
      }
    });
  }

  static void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    remainingTime = 0;
    cancelNotification();
  }

  static Future<void> showInteractiveNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'focus_timer_channel',
          'Focus Timer',
          channelDescription: 'إشعار تشغيل المؤقت',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          silent: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('stop_action', 'إيقاف المؤقت'),
            AndroidNotificationAction('reset_action', 'إعادة ضبط'),
          ],
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'التركيز مستمر ⏳',
      'الوقت المتبقي: ${remainingTime ~/ 60}:${remainingTime % 60}',
      platformChannelSpecifics,
      payload: 'stop_timer',
    );
  }

  static Future<void> cancelNotification() async {
    await FlutterLocalNotificationsPlugin().cancel(0);
  }
}
