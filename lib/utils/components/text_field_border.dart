import 'package:flutter/material.dart';

OutlineInputBorder border() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black.withAlpha(25), width: 0.4),
  );
}
