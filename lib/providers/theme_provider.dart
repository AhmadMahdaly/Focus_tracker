import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  final Box settingsBox = Hive.box('settingsBox');

  ThemeProvider() {
    _isDarkMode = settingsBox.get('darkMode', defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    settingsBox.put('darkMode', _isDarkMode);
    notifyListeners(); // تحديث واجهة المستخدم
  }
}
