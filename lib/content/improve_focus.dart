import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/widgets/text_body.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class ImproveFocus extends StatelessWidget {
  const ImproveFocus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Improve Focus title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        centerTitle: true,
        leading: const LeadingIcon(),
      ),
      body: SingleChildScrollView(child: TextBody(text: 'Improve Focus'.tr())),
    );
  }
}
