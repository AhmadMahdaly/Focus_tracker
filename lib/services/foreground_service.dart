import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// تهيئة إعدادات الخدمة
Future<void> initForegroundTask() async {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'focus_timer_channel',
      channelName: 'Focus Timer Service',
      channelDescription: 'Background timer service',
      channelImportance: NotificationChannelImportance.DEFAULT,
      priority: NotificationPriority.DEFAULT,
      showWhen: false,
      showBadge: false,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(20000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

/// تشغيل الخدمة
Future<void> startForegroundTask() async {
  await FlutterForegroundTask.startService(
    notificationTitle: 'Timer Running ⏳',
    notificationText: 'Just keep focusing!',
  );
}

/// إيقاف الخدمة
Future<void> stopForegroundTask() async {
  /// تهيئة إعدادات الخدمة
  await FlutterForegroundTask.stopService();
}
