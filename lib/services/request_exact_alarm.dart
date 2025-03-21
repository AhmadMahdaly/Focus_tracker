import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionService {
  static Future<void> requestExactAlarmPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await openAppSettings(); // فتح الإعدادات للسماح بالإذن يدويًا
      } else {
        ///
      }
    }
  }
}
