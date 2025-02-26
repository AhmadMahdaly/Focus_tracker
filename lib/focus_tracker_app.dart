import 'package:flutter/material.dart';
import 'package:focus_tracker/home_screen.dart';

class FocusTrackerApp extends StatelessWidget {
  const FocusTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
