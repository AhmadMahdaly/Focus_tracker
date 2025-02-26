import 'package:flutter/material.dart';
import 'package:focus_tracker/providers/theme_provider.dart';
import 'package:focus_tracker/screens/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class FocusTrackerApp extends StatelessWidget {
  const FocusTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            darkTheme: ThemeData.dark(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            title: 'Focus Tracker',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
