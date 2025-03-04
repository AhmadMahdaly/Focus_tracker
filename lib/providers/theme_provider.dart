import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _isDarkMode = settingsBox.get('darkMode', defaultValue: false) as bool;
  }
  bool _isDarkMode = false;
  final settingsBox = Hive.box('settingsBox');

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    settingsBox.put('darkMode', _isDarkMode);
    notifyListeners(); // تحديث واجهة المستخدم
  }
}
