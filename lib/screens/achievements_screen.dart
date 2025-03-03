import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/models/achievement_model/achievement_model.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  @override
  void initState() {
    context.read<StatsCubit>().initializeAchievements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsCubitState>(
      builder: (context, state) {
        final cubit = context.read<StatsCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "🏅 Achievements",
              style: TextStyle(fontWeight: FontWeight.w200),
            ),

            leading: LeadingIcon(),
          ),
          body: ListView.builder(
            itemCount: cubit.achievementsBox.length,
            itemBuilder: (context, index) {
              final achievement =
                  cubit.achievementsBox.getAt(index) as AchievementModel;

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
      },
    );
  }
}
