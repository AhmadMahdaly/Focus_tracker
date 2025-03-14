import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, {int duration = 4}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: duration),
      content: Text(
        text,
        style: const TextStyle(),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
