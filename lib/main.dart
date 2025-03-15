import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/focus_tracker_app.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/models/task_model/task_model.dart';
import 'package:focus_tracker/services/foreground_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  /// تهيئة Hive
  await Hive.initFlutter();

  /// تسجيل Adapter لموديل Task
  Hive
    ..registerAdapter(TaskAdapter())
    ..registerAdapter(SessionAdapter())
    ..registerAdapter(AchievementModelAdapter());

  /// فتح الـ Box لتخزين المهام
  await openBoxs();

  ///
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await initForegroundTask(); // تهيئة الخدمة عند تشغيل التطبيق

  /// طلب إذن الإشعارات على Android 13+
  if (Platform.isAndroid) {
    await Permission.notification.request();
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
    if (!await FlutterForegroundTask.canScheduleExactAlarms) {
      await FlutterForegroundTask.openAlarmsAndRemindersSettings();
    }
  }
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: FocusTrackerApp(prefs: prefs),
    ),
  );
}

Future<void> openBoxs() async {
  if (!Hive.isBoxOpen('tasksBox')) {
    await Hive.openBox<Task>('tasksBox');
  }
  if (!Hive.isBoxOpen('sessionsBox')) {
    await Hive.openBox<Session>('sessionsBox');
  }
  if (!Hive.isBoxOpen('achievementsBox')) {
    await Hive.openBox<AchievementModel>('achievementsBox');
  }
  if (!Hive.isBoxOpen('goalBox')) {
    await Hive.openBox('goalBox');
  }
  if (!Hive.isBoxOpen('settingsbox')) {
    await Hive.openBox('settingsbox');
  }
  return;
}
