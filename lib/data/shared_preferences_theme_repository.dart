import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import '../interfaces/theme_repository.dart';

class SharedPreferencesThemeRepository implements ThemeRepository {
  @override
  Future<ThemeMode> load() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(StorageKeys.themeMode) == ThemeMode.dark.name
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  Future<void> save(ThemeMode mode) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(StorageKeys.themeMode, mode.name);
  }
}
