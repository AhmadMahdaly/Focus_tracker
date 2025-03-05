import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/about_app.dart';
import 'package:focus_tracker/screens/achievements_screen.dart';
import 'package:focus_tracker/screens/settings_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const LeadingIcon()),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: const Text('Productivity Stats'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),

          ListTile(
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
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutApp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
