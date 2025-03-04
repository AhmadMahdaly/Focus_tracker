import 'package:flutter/material.dart';

class LeadingIcon extends StatelessWidget {
  const LeadingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context); // إزالة جميع الصفحات
      },
      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
    );
  }
}
