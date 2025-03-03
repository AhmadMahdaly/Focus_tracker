part of 'stats_cubit.dart';

@immutable
sealed class StatsCubitState {}

final class StatsInitial extends StatsCubitState {}

final class GenerateChartData extends StatsCubitState {}

final class GenerateWeekDays extends StatsCubitState {}

final class SaveGoal extends StatsCubitState {}

final class GetGoal extends StatsCubitState {}

final class UnlockAchievement extends StatsCubitState {}

final class SendAchievementNotification extends StatsCubitState {}

final class InitializeAchievements extends StatsCubitState {}
