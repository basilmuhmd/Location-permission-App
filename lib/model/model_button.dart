import 'package:flutter/material.dart';

class ButtonModel {
  final String btnname;
  final Color btnColor;
  final VoidCallback onTap;

  ButtonModel(
      {required this.btnname, required this.btnColor, required this.onTap});
}
