import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/services/foreground_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

part 'timer_manegment_state.dart';

class TimerManegmentCubit extends Cubit<TimerManegmentState> {
  TimerManegmentCubit() : super(TimerManegmentInitial());

  final int focusMinutes = 25; // المدة الافتراضية 25 دقيقة
  int focusSeconds = 1500; // 25 دقيقة (25 × 60 ثانية)
  bool isRunning = false;
  int time = 0;

  void startTimer() {
    isRunning = true;
    Future.delayed(const Duration(seconds: 1), tick);
    startForegroundTask(); // بدء الخدمة
    emit(TimerStartedState());
  }

  void pauseTimer() {
    isRunning = false;
    emit(TimerPausedState());
  }

  Future<void> stopTimer() async {
    isRunning = false;
    await saveSession(time / 60);
    resetTimer();
    await stopForegroundTask(); // إيقاف الخدمة
    emit(TimerStoppedState());
  }

  void tick() {
    if (focusSeconds > 0 && isRunning) {
      focusSeconds--;
      time++;
      Future.delayed(const Duration(seconds: 1), tick);
      emit(TimerTickedState());
    } else if (focusSeconds == 0) {
      resetTimer();
      saveSession(time / 60);
      playTimerSound();
      onSessionEndNotification();
      Future.delayed(const Duration(minutes: 5), scheduleNotification);
      StatsCubit().initializeAchievements();
      emit(TimerCompletedState());
    } else {
      pauseTimer();
    }
  }

  Future<void> saveSession(double focusTime) async {
    final sessionBox = Hive.box<Session>('sessionsBox');
    final session = Session(date: DateTime.now(), duration: focusTime.toInt());
    await sessionBox.add(session);
    emit(TimerSessionSavedState());
  }

  void resetTimer() {
    isRunning = false;
    focusSeconds = 1500;
    emit(TimerResetState());
  }

  String formatTime() {
    final minutes = focusSeconds ~/ 60;
    final remainingSeconds = focusSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> onSessionEndNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'focus_channel',
      'Focus Timer',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      '🎉 Focus session ended!'.tr(),
      'Take a short break and then start a new session. ☕'.tr(),
      notificationDetails,
    );
    playTimerSound();
    emit(TimerNotificationState());
  }

  Future<void> scheduleNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'focus_channel',
      'Focus Timer',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      5, // معرف مختلف عن إشعار البدء
      'Break time is over! 🚀'.tr(),
      '5 minutes have passed since the session ended. Start another session! 🌟'
          .tr(),
      notificationDetails,
    );

    emit(TimerSessionEndState());
  }

  void playTimerSound() {
    final player = AudioPlayer();
    final sound =
        Hive.box('settingsBox').get('timerSound', defaultValue: 'default')
            as String;
    switch (sound) {
      case 'bell':
        player.play(AssetSource('sounds/bell.wav'));
      case 'buzz':
        player.play(AssetSource('sounds/buzz.wav'));
      default:
        player.play(AssetSource('sounds/default.wav'));
    }
    emit(TimerSoundState());
  }
}
