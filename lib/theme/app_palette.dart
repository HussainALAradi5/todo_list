import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.border,
    required this.primary,
    required this.primarySoft,
    required this.progressCard,
    required this.progressText,
    required this.progressMuted,
    required this.checkboxBorder,
  });

  final Color background;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color border;
  final Color primary;
  final Color primarySoft;
  final Color progressCard;
  final Color progressText;
  final Color progressMuted;
  final Color checkboxBorder;

  static const light = AppPalette(
    background: Color(0xFFF7F8FA),
    surface: Colors.white,
    ink: Color(0xFF171B2B),
    muted: Color(0xFF858A99),
    border: Color(0xFFECEEF2),
    primary: Color(0xFF705CF6),
    primarySoft: Color(0xFFEFEAFF),
    progressCard: Color(0xFF171B2B),
    progressText: Colors.white,
    progressMuted: Color(0xFFA9ADBD),
    checkboxBorder: Color(0xFFCED2DC),
  );

  static const dark = AppPalette(
    background: Color(0xFF10131C),
    surface: Color(0xFF1B2030),
    ink: Color(0xFFF4F5FA),
    muted: Color(0xFFA6AEC0),
    border: Color(0xFF30384B),
    primary: Color(0xFFAD9BFF),
    primarySoft: Color(0xFF302B4E),
    progressCard: Color(0xFF322B52),
    progressText: Colors.white,
    progressMuted: Color(0xFFD0CBE3),
    checkboxBorder: Color(0xFF697388),
  );
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette => Theme.of(this).brightness == Brightness.dark
      ? AppPalette.dark
      : AppPalette.light;
}
