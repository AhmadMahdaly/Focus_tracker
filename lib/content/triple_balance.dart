import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/content/widgets/text_body.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class TripleBalance extends StatelessWidget {
  const TripleBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'The Triple Balance title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
        ),
        leading: const LeadingIcon(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: TextBody(text: 'The Triple Balance'.tr()),
      ),
    );
  }
}
