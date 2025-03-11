import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/cubit/timer_manegment_cubit/timer_manegment_cubit.dart';
import 'package:focus_tracker/screens/about_app.dart';
import 'package:focus_tracker/screens/achievements_screen.dart';
import 'package:focus_tracker/screens/settings_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerManegmentCubit, TimerManegmentState>(
      builder: (context, state) {
        final cubit = context.read<TimerManegmentCubit>();
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: PopupMenuButton(
              icon: const Icon(Icons.menu_rounded),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.analytics_outlined),
                        title: const Text('Productivity Stats'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StatsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.star_border_rounded),
                        title: const Text('Achievements'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AchievementsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About App'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutApp(),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('Settings'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
            ),
          ),
          body: Center(
            child: ListView(
              children: [
                const SizedBox(height: 100),
                CircularPercentIndicator(
                  radius: 100,
                  lineWidth: 10,
                  percent: cubit.focusSeconds / 1500,
                  center: Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cubit.formatTime(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'JUST FOCUS',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                  restartAnimation: true,
                  progressColor: Colors.blue,
                ),
                const SizedBox(height: 30),
                if (cubit.isRunning)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          cubit.stopTimer();
                          context.read<StatsCubit>().initializeAchievements();
                        },
                        icon: const Icon(Icons.stop_rounded, size: 50),
                      ),
                      IconButton(
                        onPressed: cubit.pauseTimer,
                        icon: const Icon(Icons.pause_rounded, size: 45),
                      ),
                    ],
                  )
                else
                  Center(
                    child: IconButton(
                      onPressed: cubit.startTimer,
                      icon: const Icon(Icons.play_arrow_rounded, size: 50),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
