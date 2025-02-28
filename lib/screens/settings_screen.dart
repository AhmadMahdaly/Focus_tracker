import 'package:flutter/material.dart';
import 'package:focus_tracker/providers/theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
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
                onTap: () => _changeSound("default"),
              ),
              ListTile(
                title: const Text("Bell"),
                onTap: () => _changeSound("bell"),
              ),
              ListTile(
                title: const Text("Buzz"),
                onTap: () => _changeSound("buzz"),
              ),
            ],
          ),
        );
      },
    );
  }
}
