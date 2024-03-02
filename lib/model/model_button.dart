import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonModel {
  final String btnname;
  final Color btnColor;
  final void Function(WidgetRef ref, BuildContext context) onTap;

  ButtonModel(
      {required this.btnname, required this.btnColor, required this.onTap});
}
