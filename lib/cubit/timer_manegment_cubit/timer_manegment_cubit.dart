import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tracker/main.dart';
import 'package:focus_tracker/models/session_model/session_model.dart';
import 'package:focus_tracker/services/foreground_service.dart';
import 'package:focus_tracker/services/notification_service.dart';
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

  void stopTimer() async {
    isRunning = false;
    saveSession(time / 60);
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
      showNotification();
      onSessionEnd();
      emit(TimerCompletedState());
    } else {
      pauseTimer();
    }
  }

  void onSessionEnd() async {
    DateTime endTime = DateTime.now(); // وقت انتهاء الجلسة
    await NotificationService.scheduleEndSessionNotification(
      2, // معرف مختلف عن إشعار البدء
      "Break time is over! 🚀",
      "5 minutes have passed since the session ended. Start another session! 🌟",
      endTime,
    );
    emit(TimerSessionEndState());
  }

  void saveSession(focusTime) async {
    final Box sessionBox = Hive.box<Session>('sessionsBox');
    final session = Session(date: DateTime.now(), duration: focusTime.toInt());
    sessionBox.add(session);
    emit(TimerSessionSavedState());
  }

  void resetTimer() {
    focusSeconds = 1500;
    stopForegroundTask(); // إيقاف الخدمة عند انتهاء المؤقت
    emit(TimerResetState());
  }

  String formatTime() {
    int minutes = focusSeconds ~/ 60;
    int remainingSeconds = focusSeconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> showNotification() async {
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
      '🎉 Focus session ended!',
      'Take a short break and then start a new session. ☕',
      notificationDetails,
    );
    emit(TimerNotificationState());
  }

  void playTimerSound() {
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
    emit(TimerSoundState());
  }
}
