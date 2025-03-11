import 'package:flutter/material.dart';

class TextBody extends StatelessWidget {
  const TextBody({required this.text, super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
  }
}
