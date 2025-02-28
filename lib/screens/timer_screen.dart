import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/widgets/custom_drawer.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  void initState() {
    openBox();
    super.initState();
  }

  final int _focusDuration = 25; // المدة الافتراضية 25 دقيقة
  ///1500
  int _seconds = 1500; // 25 دقيقة (25 × 60 ثانية)
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
    } else if (_seconds == 0) {
      _resetTimer();
      _saveSession();
      _playTimerSound();
      _showNotification();
      _saveFocusTime();
    } else {
      _resetTimer();
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
      _seconds = 1500;
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

  void _playTimerSound() {
    final player = AudioPlayer();
    String sound = Hive.box(
      'settingsBox',
    ).get('timerSound', defaultValue: "default");

    switch (sound) {
      case "bell":
        player.play(AssetSource('sounds/bell.wav'));
        break;
      case "buzz":
        player.play(AssetSource('sounds/buzz.wav'));
        break;
      default:
        player.play(AssetSource('sounds/default.wav'));
    }
  }

  void _saveFocusTime() {
    final Box statsBox = Hive.box('statsBox');
    String today =
        DateTime.now().weekday.toString(); // تحويل اليوم إلى رقم (1-7)
    double currentFocus = statsBox.get(today, defaultValue: 0.0);
    statsBox.put(
      today,
      currentFocus + (_focusDuration / 60),
    ); // تخزين عدد الساعات
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            // SizedBox(height: 250, child: TasksScreen()),
            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Divider(color: Colors.blue, thickness: 0.4),
            // ),
            const SizedBox(height: 100),
            CircularPercentIndicator(
              radius: 100,
              lineWidth: 10,

              ///1500
              percent: _seconds / 1500,
              center: Column(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_seconds),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'JUST FOCUS',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              restartAnimation: true,
              progressColor: Colors.blue,
            ),
            const SizedBox(height: 30),
            _isRunning
                ? Center(
                  child: IconButton(
                    onPressed: _resetTimer,
                    icon: Icon(Icons.stop_rounded, size: 50),
                  ),
                )
                : Center(
                  child: IconButton(
                    onPressed: _startTimer,
                    icon: Icon(Icons.play_arrow_rounded, size: 50),
                  ),
                ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}
