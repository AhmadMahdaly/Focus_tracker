import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/effective_ways.dart';
import 'package:focus_tracker/content/improve_focus.dart';
import 'package:focus_tracker/content/mindfulness.dart';
import 'package:focus_tracker/content/pursuit_growth_development.dart';
import 'package:focus_tracker/content/triple_balance.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const LeadingIcon()),
      body: ListView(
        children: [
          ListTile(
            title: Text('Improve Focus title'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ImproveFocus()),
              );
            },
          ),

          ListTile(
            title: Text('The Triple Balance title'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TripleBalance()),
              );
            },
          ),
          ListTile(
            title: Text('Effective Ways title'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EffectiveWays()),
              );
            },
          ),
          ListTile(
            title: Text('The Pursuit of Growth and Development title'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PursuitGrowthDevelopment(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Mindfulness title'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Mindfulness()),
              );
            },
          ),
        ],
      ),
    );
  }
}
