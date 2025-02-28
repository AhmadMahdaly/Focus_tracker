import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/achievements_screen.dart';
import 'package:focus_tracker/screens/settings_screen.dart';
import 'package:focus_tracker/screens/statistics_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: Icon(Icons.arrow_forward),
                ),
                Text(''),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.analytics_outlined),
            title: Text("Statistics"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.stay_current_landscape),
            title: Text("Statistics"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatisticsScreen()),
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
