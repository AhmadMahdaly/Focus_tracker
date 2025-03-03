part of 'task_manegment_cubit.dart';

@immutable
sealed class TaskManegmentState {}

final class TaskInitial extends TaskManegmentState {}

final class AddTask extends TaskManegmentState {}

final class TaskDeleted extends TaskManegmentState {}

final class AllTasksDeleted extends TaskManegmentState {}

final class TaskUpdated extends TaskManegmentState {}
