import 'package:flutter/material.dart';

OutlineInputBorder border() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent, width: 0.4),
  );
}
