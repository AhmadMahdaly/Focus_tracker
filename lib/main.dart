import 'package:flutter/material.dart';
import 'package:focus_tracker/focus_tracker_app.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/models/task_model/task_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// تهيئة Hive
  await Hive.initFlutter();

  /// تسجيل Adapter لموديل Task
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SessionAdapter());

  /// فتح الـ Box لتخزين المهام
  await Hive.openBox<Task>('tasksBox');
  await Hive.openBox<Session>('sessionsBox');
  await Hive.openBox('goalBox');

  ///
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  /// طلب إذن الإشعارات على Android 13+
  if (Platform.isAndroid) {
    if (await Permission.notification.request().isGranted) {
      print("تم منح إذن الإشعارات ✅");
    } else {
      print("🔴 لم يتم منح إذن الإشعارات");
    }
  }
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const FocusTrackerApp(),
    ),
  );
}
