import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:focus_tracker/focus_tracker_app.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/models/task_model/task_model.dart';
import 'package:focus_tracker/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// تهيئة Hive
  await Hive.initFlutter();

  /// تسجيل Adapter لموديل Task
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(AchievementModelAdapter());

  /// فتح الـ Box لتخزين المهام
  await Hive.openBox<Task>('tasksBox');
  await Hive.openBox<Session>('sessionsBox');
  await Hive.openBox('goalBox');
  await Hive.openBox<AchievementModel>('achievementsBox');
  await Hive.openBox('settingsBox');
  await Hive.openBox('statsBox');

  ///
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
  await NotificationService.init();

  /// طلب إذن الإشعارات على Android 13+
  if (Platform.isAndroid) {
    if (await Permission.notification.request().isGranted) {
      log("تم منح إذن الإشعارات ✅");
    } else {
      log("🔴 لم يتم منح إذن الإشعارات");
    }
  }
  runApp(const FocusTrackerApp());
}
