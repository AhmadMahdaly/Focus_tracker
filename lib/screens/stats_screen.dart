import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/utils/components/text_field_border.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/session_model/session_model.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final TextEditingController _goalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('sessionsBox')) {
      await Hive.openBox<Session>('sessionsBox');
    }
  }

  List<FlSpot> _generateChartData(Box sessionBox) {
    Map<int, int> weeklyData = {};

    for (var i = 0; i < 7; i++) {
      weeklyData[i] = 0;
    }

    for (var i = 0; i < sessionBox.length; i++) {
      final session = sessionBox.getAt(i) as Session;
      final int dayIndex = DateTime.now().difference(session.date).inDays;
      if (dayIndex < 7) {
        weeklyData[6 - dayIndex] =
            (weeklyData[6 - dayIndex] ?? 0) + session.duration;
      }
    }

    return weeklyData.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
  }

  List<String> generateWeekDays() {
    List<String> weekDays = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    int todayIndex = DateTime.now().weekday; //
    return [
      ...weekDays.sublist(todayIndex),
      ...weekDays.sublist(0, todayIndex),
    ];
  }

  void _saveGoal(int goal) async {
    final Box goalBox = Hive.box('goalBox');
    goalBox.put('weeklyGoal', goal);
  }

  int _getGoal() {
    final Box goalBox = Hive.box('goalBox');
    return goalBox.get('weeklyGoal', defaultValue: 300); // الافتراضي 300 دقيقة
  }

  late int goal = 300;
  Future<void> _sendNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'productivity_channel',
          'Productivity Notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  bool _hasSent50PercentNotification = false;
  bool _hasSent100PercentNotification = false;
  @override
  Widget build(BuildContext context) {
    final Box sessionBox = Hive.box<Session>('sessionsBox');

    int totalFocusTime = sessionBox.values.fold(
      0,
      (sum, session) => sum + (session as Session).duration,
    );
    int sessionCount = sessionBox.length;
    int weeklyGoal = _getGoal();
    double progress = totalFocusTime / weeklyGoal;
    if (progress >= 0.5 && !_hasSent50PercentNotification) {
      _sendNotification(
        "🎯 تقدم رائع!",
        "لقد أكملت 50% من هدفك الأسبوعي، واصل العمل! 🚀",
      );
      _hasSent50PercentNotification = true;
    }

    if (progress >= 1.0 && !_hasSent100PercentNotification) {
      _sendNotification(
        "🏆 هدف محقق!",
        "رائع! لقد أكملت 100% من هدفك الأسبوعي، استمر في الإنجاز! 🎉",
      );
      _hasSent100PercentNotification = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات الإنتاجية'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  'إجمالي وقت التركيز: $totalFocusTime دقيقة',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'عدد الجلسات المكتملة: $sessionCount',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> days = generateWeekDays();
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateChartData(sessionBox),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withAlpha(50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _goalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "حدد هدف الإنتاجية الأسبوعي (دقائق)",
                border: border(),
                focusedBorder: border(),
                enabledBorder: border(),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
              onSubmitted: (value) {
                goal =
                    int.tryParse(value) ??
                    300; // إذا لم يدخل المستخدم قيمة صحيحة
                _saveGoal(goal);
                setState(() {});
              },
            ),
            const SizedBox(height: 20),

            LinearProgressIndicator(
              borderRadius: BorderRadius.circular(8),
              value: progress > 1 ? 1 : progress, // لا يتجاوز 100%
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            Text('$goal عدد دقائق الهدف الأسبوعي:'),
            Text('$totalFocusTime عدد الدقائق المنجزة:'),

            Text(
              "${(progress * 100).toStringAsFixed(0)}% ما تم تحقيقه من الهدف الأسبوعي:",
            ),
          ],
        ),
      ),
    );
  }
}
