import 'package:flutter/material.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:hive/hive.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final Box<AchievementModel> achievementsBox = Hive.box<AchievementModel>(
    'achievementsBox',
  );
  @override
  void initState() {
    super.initState();
    initializeAchievements();
  }

  void initializeAchievements() async {
    if (achievementsBox.isEmpty) {
      List<AchievementModel> achievements = [
        AchievementModel(
          title: "Beginner 🎯",
          description: "Complete the first focus session",
        ),
        AchievementModel(
          title: "Diligent 🔥",
          description: "Complete 5 focus sessions",
        ),
        AchievementModel(
          title: "Halfway 🏆",
          description: "Achieve 50% of your weekly goal",
        ),
        AchievementModel(
          title: "Champion 🚀",
          description: "Achieve 100% of your weekly goal",
        ),
      ];

      for (var achievement in achievements) {
        achievementsBox.add(achievement);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏅 Achievements"), centerTitle: true),
      body: ListView.builder(
        itemCount: achievementsBox.length,
        itemBuilder: (context, index) {
          final achievement = achievementsBox.getAt(index) as AchievementModel;

          return ListTile(
            leading:
                achievement.isUnlocked
                    ? const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 32,
                    )
                    : const Icon(Icons.lock, color: Colors.grey, size: 32),
            title: Text(achievement.title),
            subtitle: Text(achievement.description),
          );
        },
      ),
    );
  }
}
