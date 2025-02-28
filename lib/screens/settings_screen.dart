import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  late Box settingsBox;
  bool isDarkMode = false;
  String selectedSound = "default";

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settingsBox');

    // تحميل القيم المحفوظة
    isDarkMode = settingsBox.get('darkMode', defaultValue: false);
    selectedSound = settingsBox.get('timerSound', defaultValue: "default");
  }

  void _changeSound(String sound) {
    setState(() {
      selectedSound = sound;
      settingsBox.put('timerSound', sound);
    });
  }

  void _playTimerSound() {
    final player = AudioPlayer();
    String sound = Hive.box(
      'settingsBox',
    ).get('timerSound', defaultValue: "default");

    switch (sound) {
      case "bell":
        player.play(AssetSource('sounds/bell.wav'));
        break;
      case "buzz":
        player.play(AssetSource('sounds/buzz.wav'));
        break;
      default:
        player.play(AssetSource('sounds/default.wav'));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text(selectedSound),
            onTap: () {
              _showSoundSelectionDialog();
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
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSoundSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Timer Sound"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Default"),
                onTap: () {
                  _changeSound("default");
                  _playTimerSound();
                },
              ),
              ListTile(
                title: const Text("Bell"),
                onTap: () {
                  _changeSound("bell");
                  _playTimerSound();
                },
              ),
              ListTile(
                title: const Text("Buzz"),
                onTap: () {
                  _changeSound("buzz");
                  _playTimerSound();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
