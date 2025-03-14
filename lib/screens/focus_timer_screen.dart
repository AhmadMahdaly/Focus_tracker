import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/cubit/timer_manegment_cubit/timer_manegment_cubit.dart';
import 'package:focus_tracker/screens/widgets/home_popup_menu.dart';
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
            leading: const HomePopupMenu(),
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
                      Text(
                        'JUST FOCUS'.tr(),
                        style: const TextStyle(
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
