import 'package:easy_localization/easy_localization.dart';
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
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(20000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWifiLock: true,
    ),
  );
}

/// تشغيل الخدمة
Future<void> startForegroundTask() async {
  await FlutterForegroundTask.startService(
    notificationTitle: 'Timer Running ⏳'.tr(),
    notificationText: 'Just keep focusing!'.tr(),
  );
}

/// إيقاف الخدمة
Future<void> stopForegroundTask() async {
  /// تهيئة إعدادات الخدمة
  await FlutterForegroundTask.stopService();
}
