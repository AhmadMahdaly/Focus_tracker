import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// تهيئة إعدادات الخدمة
Future<void> initForegroundTask() async {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'focus_timer_channel',
      channelName: 'Focus Timer Service',
      channelDescription: 'خدمة تشغيل المؤقت في الخلفية',
      channelImportance: NotificationChannelImportance.HIGH,
      priority: NotificationPriority.HIGH,

      showWhen: true,
      showBadge: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(5000),
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
    notificationTitle: 'المؤقت يعمل ⏳',
    notificationText: 'المؤقت سيبقى يعمل حتى بعد إغلاق التطبيق.',
  );
}

/// إيقاف الخدمة
Future<void> stopForegroundTask() async {
  /// تهيئة إعدادات الخدمة
  await FlutterForegroundTask.stopService();
}
