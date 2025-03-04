import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmPermissionService {
  static Future<void> requestExactAlarmPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.scheduleExactAlarm.isDenied) {
        await openAppSettings(); // فتح الإعدادات للسماح بالإذن يدويًا
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚠️ يرجى تمكين إذن التنبيهات الدقيقة من الإعدادات'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ إذن التنبيهات الدقيقة مفعل بالفعل!')),
        );
      }
    }
  }
}
