import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF7F8FA);
  static const ink = Color(0xFF171B2B);
  static const muted = Color(0xFF858A99);
  static const purple = Color(0xFF705CF6);
  static const purpleSoft = Color(0xFFEFEAFF);
  static const border = Color(0xFFECEEF2);
  static const coral = Color(0xFFFF826F);
  static const mint = Color(0xFF5BC9A6);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.purple,
      surface: Colors.white,
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 31,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.2,
        color: AppColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -.5,
        color: AppColors.ink,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.ink),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: const TextStyle(color: AppColors.muted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    ),
  );
}
