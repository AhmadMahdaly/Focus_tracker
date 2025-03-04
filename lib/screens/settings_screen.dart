import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/setting_cubit/setting_cubit.dart';
import 'package:focus_tracker/cubit/stats_cubit/stats_cubit.dart';
import 'package:focus_tracker/cubit/task_manegment_cubit/task_manegment_cubit.dart';
import 'package:focus_tracker/providers/theme_provider.dart';
import 'package:focus_tracker/services/notification_service.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingCubit>().initSettings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        final cubit = context.read<SettingCubit>();
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            leading: const LeadingIcon(),
          ),
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Timer Sound'),
                subtitle: Text(cubit.selectedSound),
                onTap: () {
                  cubit.showSoundSelectionDialog(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Enable Daily Reminder'),
                trailing: Switch(
                  value:
                      cubit.settingsBox.get(
                            'dailyReminder',
                            defaultValue: false,
                          )
                          as bool,
                  onChanged: (value) {
                    setState(() {
                      cubit.settingsBox.put('dailyReminder', value);
                      if (value) {
                        NotificationService.scheduleDailyReminder();
                      } else {
                        cubit.settingsBox.clear();
                        // NotificationService.cancelDailyReminder();
                      }
                    });
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Clear All Data'),

                onTap: () {
                  context
                    ..read<StatsCubit>().resetAllData()
                    ..read<TaskManegmentCubit>().deleteAllTasks();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All data has been cleared')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
