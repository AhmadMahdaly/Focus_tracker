import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/setting_cubit/setting_cubit.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';
import 'package:focus_tracker/cubit/timer_manegment_cubit/timer_manegment_cubit.dart';

class MainBlocProvider extends StatelessWidget {
  const MainBlocProvider({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TimerManegmentCubit>(
          create: (context) => TimerManegmentCubit(),
        ),
        BlocProvider<TaskManegmentCubit>(
          create: (context) => TaskManegmentCubit(),
        ),
        BlocProvider<StatsCubit>(create: (context) => StatsCubit()),
        BlocProvider<SettingCubit>(create: (context) => SettingCubit()),
      ],
      child: child,
    );
  }
}
