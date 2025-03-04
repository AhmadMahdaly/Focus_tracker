import 'package:hive/hive.dart';

part 'session_model.g.dart';

@HiveType(typeId: 1)
class Session {
  // مدة الجلسة بالدقائق

  Session({required this.date, required this.duration});
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int duration;
}

/// dart run build_runner build
