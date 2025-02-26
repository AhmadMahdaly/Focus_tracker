import 'package:flutter/material.dart';
import 'package:focus_tracker/screens/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class FocusTrackerApp extends StatelessWidget {
  const FocusTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Tracker',

      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
