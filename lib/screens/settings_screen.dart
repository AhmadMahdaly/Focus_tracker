import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_tracker/cubit/setting_cubit/setting_cubit.dart';
import 'package:focus_tracker/providers/theme_provider.dart';
import 'package:focus_tracker/services/notification_service.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';
import 'package:hive/hive.dart';
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
              "Settings",
              style: TextStyle(fontWeight: FontWeight.w200),
            ),
            leading: LeadingIcon(),
          ),
          body: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text("Dark Mode"),
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
                title: const Text("Timer Sound"),
                subtitle: Text(cubit.selectedSound),
                onTap: () {
                  cubit.showSoundSelectionDialog(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text("Enable Daily Reminder"),
                trailing: Switch(
                  value: Hive.box(
                    'settingsBox',
                  ).get('dailyReminder', defaultValue: false),
                  onChanged: (value) {
                    setState(() {
                      Hive.box('settingsBox').put('dailyReminder', value);
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
            ],
          ),
        );
      },
    );
  }
}
