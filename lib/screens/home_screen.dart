import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/screens/achievements_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';
import 'package:focus_tracker/screens/tasks_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    openBox();
    super.initState();
  }

  final int _focusDuration = 25; // المدة الافتراضية 25 دقيقة
  ///1500
  int _seconds = 30; // 25 دقيقة (25 × 60 ثانية)
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    Future.delayed(const Duration(seconds: 1), _tick);
  }

  void _tick() {
    if (_seconds > 0 && _isRunning) {
      setState(() {
        _seconds--;
      });
      Future.delayed(const Duration(seconds: 1), _tick);
    } else {
      _saveSession();
      setState(() {
        _seconds = 30;
        _isRunning = false;
      });
      _showNotification(); // إرسال الإشعار عند انتهاء الوقت
    }
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('achievementsBox')) {
      await Hive.openBox<AchievementModel>('achievementsBox');
    }
    if (!Hive.isBoxOpen('sessionsBox')) {
      await Hive.openBox<Session>('sessionsBox');
    }
  }

  void _saveSession() async {
    final Box sessionBox = Hive.box<Session>('sessionsBox');
    final session = Session(date: DateTime.now(), duration: _focusDuration);
    sessionBox.add(session);
  }

  void _resetTimer() {
    setState(() {
      ///1500
      _seconds = 30;
      _isRunning = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'focus_channel',
          'Focus Timer',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'انتهت جلسة التركيز!',
      'خذ استراحة قصيرة ثم ابدأ جلسة جديدة.',
      notificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Tracker'), centerTitle: true),
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 250, child: TasksScreen()),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Divider(color: Colors.blue, thickness: 0.4),
            ),
            const SizedBox(height: 20),

            CircularPercentIndicator(
              radius: 100,
              lineWidth: 10,

              ///1500
              percent: _seconds / 30,
              center: Text(
                _formatTime(_seconds),
                style: const TextStyle(fontSize: 24),
              ),
              progressColor: Colors.blue,
            ),
            const SizedBox(height: 20),
            _isRunning
                ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _resetTimer,
                    child: const Text(
                      "إنهاء الجلسة",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
                : Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: _startTimer,
                    child: const Text(
                      "ابدأ التركيز",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('')),
            ListTile(
              leading: Icon(Icons.task_alt_outlined),
              title: Text("المهام"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TasksScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/analytic-server.png',
                width: 20,
                height: 20,
                color: Colors.black87,
              ),
              title: Text("الإحصائيات"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border_rounded),
              title: Text("الإنجازات"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AchievementsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
