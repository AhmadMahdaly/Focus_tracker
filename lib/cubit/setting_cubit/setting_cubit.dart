import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(SettingInitial());
  final settingsBox = Hive.box('settingsBox');
  bool isDarkMode = false;
  String selectedSound = 'default';

  void initSettings() {
    // تحميل القيم المحفوظة
    isDarkMode = settingsBox.get('darkMode', defaultValue: false) as bool;
    selectedSound =
        settingsBox.get('timerSound', defaultValue: 'default') as String;
  }

  void changeSound(String sound) {
    selectedSound = sound;
    settingsBox.put('timerSound', sound);
  }

  void playTimerSound() {
    final player = AudioPlayer();
    final sound =
        settingsBox.get('timerSound', defaultValue: 'default') as String;

    switch (sound) {
      case 'bell':
        player.play(AssetSource('sounds/bell.wav'));
      case 'buzz':
        player.play(AssetSource('sounds/buzz.wav'));
      default:
        player.play(AssetSource('sounds/default.wav'));
    }
  }

  void showSoundSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Timer Sound'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Default'.tr()),
                onTap: () {
                  changeSound('default');
                  playTimerSound();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Bell'.tr()),
                onTap: () {
                  changeSound('bell');
                  playTimerSound();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Buzz'.tr()),
                onTap: () {
                  changeSound('buzz');
                  playTimerSound();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
