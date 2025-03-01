import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

class FocusTimerService {
  static Future<void> saveLastSession(int duration, DateTime endTime) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('last_session_duration', duration);
    prefs.setString('last_session_end', endTime.toIso8601String());

    // تحديث الويدجت بعد حفظ البيانات
    WidgetKit.reloadAllTimelines();
  }

  static Future<Map<String, dynamic>?> getLastSession() async {
    final prefs = await SharedPreferences.getInstance();
    final int? duration = prefs.getInt('last_session_duration');
    final String? end = prefs.getString('last_session_end');

    if (duration != null && end != null) {
      return {'duration': duration, 'endTime': DateTime.parse(end)};
    }
    return null;
  }
}
