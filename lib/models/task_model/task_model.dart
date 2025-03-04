import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task {
  Task({required this.title, this.isCompleted = false});
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;
}

/// dart run build_runner build
