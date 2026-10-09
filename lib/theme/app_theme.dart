import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppColors {
  static const coral = Color(0xFFFF826F);
  static const mint = Color(0xFF5BC9A6);
}

class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) =>
      ThemeData(
        useMaterial3: true,
        brightness: brightness,
        scaffoldBackgroundColor: palette.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: palette.primary,
          brightness: brightness,
          surface: palette.surface,
          onSurface: palette.ink,
        ).copyWith(primary: palette.primary, outlineVariant: palette.border),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 31,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.2,
            color: palette.ink,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
            color: palette.ink,
          ),
          bodyMedium: TextStyle(fontSize: 14, color: palette.ink),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: palette.surface,
          hintStyle: TextStyle(color: palette.muted),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: palette.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: palette.border),
          ),
        ),
      );
}
