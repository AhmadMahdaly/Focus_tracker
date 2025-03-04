import 'package:hive/hive.dart';

part 'achievement_model.g.dart';

@HiveType(typeId: 2)
class AchievementModel extends HiveObject {
  AchievementModel({
    required this.title,
    required this.description,
    this.isUnlocked = false,
  });
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isUnlocked;
}

/// dart run build_runner build
