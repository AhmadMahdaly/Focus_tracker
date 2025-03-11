import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/widgets/text_body.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class Mindfulness extends StatelessWidget {
  const Mindfulness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mindfulness title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
        centerTitle: true,
        leading: const LeadingIcon(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(child: TextBody(text: 'Mindfulness'.tr())),
      ),
    );
  }
}
