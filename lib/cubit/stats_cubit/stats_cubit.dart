import 'package:bloc/bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'stats_state.dart';

class StatsCubit extends Cubit<StatsCubitState> {
  StatsCubit() : super(StatsInitial());

  List<FlSpot> generateChartData(Box<Session> sessionBox) {
    final weeklyData = <int, int>{};

    for (var i = 0; i < 7; i++) {
      weeklyData[i] = 0;
    }

    for (var i = 0; i < sessionBox.length; i++) {
      final session = sessionBox.getAt(i)!;
      final dayIndex = DateTime.now().difference(session.date).inDays;
      if (dayIndex < 7) {
        weeklyData[6 - dayIndex] =
            (weeklyData[6 - dayIndex] ?? 0) + session.duration;
      }
    }
    emit(GenerateChartData());
    return weeklyData.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
  }

  List<String> generateWeekDays() {
    final weekDays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final todayIndex = DateTime.now().weekday; //
    emit(GenerateWeekDays());
    return [
      ...weekDays.sublist(todayIndex),
      ...weekDays.sublist(0, todayIndex),
    ];
  }

  final goalBox = Hive.box('goalBox');
  final Box<Session> sessionBox = Hive.box<Session>('sessionsBox');
  final Box<AchievementModel> achievementsBox = Hive.box<AchievementModel>(
    'achievementsBox',
  );
  Future<void> saveGoal(int goal) async {
    await goalBox.put('weeklyGoal', goal);
    emit(SaveGoal());
  }

  int getGoal() {
    emit(GetGoal());
    return goalBox.get('weeklyGoal', defaultValue: 0)!
        as int; // الافتراضي 300 دقيقة
  }

  late int goal = 0;
  Future<void> sendNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'productivity_channel',
      'Productivity Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  int totalFocusTime() {
    return sessionBox.values.fold(0, (sum, session) => sum + session.duration);
  }

  int sessionCount() {
    return sessionBox.length;
  }

  int weeklyGoal() => getGoal();
  double progress() => totalFocusTime() / weeklyGoal();

  bool hasSent50PercentNotification = false;
  bool hasSent100PercentNotification = false;

  void unlockAchievement(String title) {
    for (var i = 0; i < achievementsBox.length; i++) {
      final achievement = achievementsBox.getAt(i)!;
      if (achievement.title == title && !achievement.isUnlocked) {
        achievement
          ..isUnlocked = true
          ..save();
      }
    }

    emit(UnlockAchievement());
  }

  void resetAllData() {
    goalBox.clear();
    sessionBox.clear();
    achievementsBox.clear();
    hasSent50PercentNotification = false;
    hasSent100PercentNotification = false;
  }

  Future<void> initializeAchievements() async {
    if (achievementsBox.isEmpty) {
      final achievements = <AchievementModel>[
        AchievementModel(
          title: 'Beginner 🎯',
          description: 'Complete the first focus session',
        ),
        AchievementModel(
          title: 'Diligent 🔥',
          description: 'Complete 5 focus sessions',
        ),
        AchievementModel(
          title: 'Halfway 🏆',
          description: 'Achieve 50% of your weekly goal',
        ),
        AchievementModel(
          title: 'Champion 🚀',
          description: 'Achieve 100% of your weekly goal',
        ),
      ];

      for (final achievement in achievements) {
        await achievementsBox.add(achievement);
      }
    }
    if (progress() >= 0.5 && !hasSent50PercentNotification) {
      await sendNotification(
        '🎯 Great Progress!',
        "You've reached 50% of your weekly goal! 🚀",
      );
      hasSent50PercentNotification = true;
    }
    if (progress() >= 1.0 && !hasSent100PercentNotification) {
      await sendNotification(
        '🏆 Goal Achieved!',
        "You've reached 100% of your weekly goal! 🎉",
      );
      hasSent100PercentNotification = true;
    }
    if (sessionCount() >= 1) {
      unlockAchievement('Beginner 🎯');
    }
    if (sessionCount() >= 5) {
      unlockAchievement('Diligent 🔥');
    }
    if (progress() >= 0.5) {
      unlockAchievement('Halfway 🏆');
    }

    if (progress() >= 1.0) {
      unlockAchievement('Champion 🚀');
    }
    emit(InitializeAchievements());
  }
}
