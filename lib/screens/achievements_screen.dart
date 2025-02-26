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
          title: "المبتدئ 🎯",
          description: "أكمل أول جلسة تركيز",
        ),
        AchievementModel(
          title: "المجتهد 🔥",
          description: "أكمل 5 جلسات تركيز",
        ),
        AchievementModel(
          title: "نصف الطريق 🏆",
          description: "حقق 50% من هدفك الأسبوعي",
        ),
        AchievementModel(
          title: "البطل 🚀",
          description: "حقق 100% من هدفك الأسبوعي",
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
      appBar: AppBar(title: const Text("🏅 الإنجازات")),
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
