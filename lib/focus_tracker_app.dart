import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/models/locale_model.dart';
import 'package:focus_tracker/providers/main_bloc_provider.dart';
import 'package:focus_tracker/providers/theme_provider.dart';
import 'package:focus_tracker/screens/navy_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusTrackerApp extends StatelessWidget {
  const FocusTrackerApp({required SharedPreferences prefs, super.key})
    : _prefs = prefs;
  final SharedPreferences _prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MainBlocProvider(
            child: ChangeNotifierProvider(
              create: (context) => LocaleModel(_prefs),
              child: Consumer<LocaleModel>(
                builder:
                    (context, localeModel, child) => MaterialApp(
                      debugShowCheckedModeBanner: false,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      theme: ThemeData(
                        fontFamily: 'Avenir',
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.blue,
                        ),
                      ),
                      darkTheme: ThemeData(
                        fontFamily: 'Avenir',
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: Colors.black,
                          brightness: Brightness.dark,
                        ),
                      ),
                      themeMode:
                          themeProvider.isDarkMode
                              ? ThemeMode.dark
                              : ThemeMode.light,
                      title: 'Focus Tracker',
                      home: const NavyBottomBar(),
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
