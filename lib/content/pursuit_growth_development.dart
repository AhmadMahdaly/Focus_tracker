import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/widgets/text_body.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class PursuitGrowthDevelopment extends StatelessWidget {
  const PursuitGrowthDevelopment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Pursuit of Growth and Development title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        leading: const LeadingIcon(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: TextBody(text: 'The Pursuit of Growth and Development'.tr()),
      ),
    );
  }
}
