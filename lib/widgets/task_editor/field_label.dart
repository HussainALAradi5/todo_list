import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: context.palette.muted,
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    ),
  );
}
