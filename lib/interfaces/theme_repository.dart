import 'package:flutter/material.dart';

abstract interface class ThemeRepository {
  Future<ThemeMode> load();

  Future<void> save(ThemeMode mode);
}
