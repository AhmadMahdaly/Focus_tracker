import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/models/locale_model.dart';
import 'package:focus_tracker/screens/navy_bottom_bar.dart';
import 'package:provider/provider.dart';

class LanguageDropDownButton extends StatelessWidget {
  const LanguageDropDownButton({required this.selectedLocale, super.key});

  final String selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleModel>(
      builder:
          (context, localeModel, child) => DropdownButton(
            value: selectedLocale,
            items: const [
              DropdownMenuItem(
                value: 'en',
                child: Text(
                  'English',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text(
                  'العربية',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ),
            ],
            onChanged: (String? value) async {
              if (value != null) {
                await context.setLocale(Locale(value));
              }
              await Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavyBottomBar()),
              );
            },
          ),
    );
  }
}
