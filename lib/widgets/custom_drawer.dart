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
      appBar: AppBar(leading: LeadingIcon()),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text("Productivity Stats"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.star_border_rounded),
            title: Text("Achievements"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("About App"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutApp()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
