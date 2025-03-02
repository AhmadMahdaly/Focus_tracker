part of 'timer_manegment_cubit.dart';

@immutable
sealed class TimerManegmentState {}

final class TimerManegmentInitial extends TimerManegmentState {}

final class TimerStartedState extends TimerManegmentState {}

final class TimerPausedState extends TimerManegmentState {}

final class TimerResetState extends TimerManegmentState {}

final class TimerStoppedState extends TimerManegmentState {}

final class TimerResumedState extends TimerManegmentState {}

final class TimerCompletedState extends TimerManegmentState {}

final class TimerTickedState extends TimerManegmentState {}

final class TimerSessionEndState extends TimerManegmentState {}

final class TimerSessionSavedState extends TimerManegmentState {}

final class TimerNotificationState extends TimerManegmentState {}

final class TimerSoundState extends TimerManegmentState {}

final class TimerFocusTimeSavedState extends TimerManegmentState {}
