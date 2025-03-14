import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/content_page.dart';
import 'package:focus_tracker/screens/about_app.dart';
import 'package:focus_tracker/screens/achievements_screen.dart';
import 'package:focus_tracker/screens/settings_screen.dart';
import 'package:focus_tracker/screens/stats_screen.dart';

class HomePopupMenu extends StatelessWidget {
  const HomePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.menu_rounded),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text('Improve Yourself'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContentPage(),
                    ),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.analytics_outlined),
                title: Text('Productivity Stats'.tr()),
                onTap: () {
                  Navigator.pop(context);
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
                title: Text('Achievements'.tr()),
                onTap: () {
                  Navigator.pop(context);
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
                title: Text('About App'.tr()),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutApp()),
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text('Settings'.tr()),
                onTap: () {
                  Navigator.pop(context);
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
    );
  }
}
