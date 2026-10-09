import 'package:flutter/material.dart';

import '../interfaces/theme_repository.dart';

class ThemeStore extends ChangeNotifier {
  ThemeStore(this._repository);

  final ThemeRepository _repository;
  ThemeMode mode = ThemeMode.light;
  bool isSaving = false;

  Future<void> load() async {
    try {
      mode = await _repository.load();
      notifyListeners();
    } catch (error) {
      debugPrint('Could not load theme: $error');
    }
  }

  Future<void> toggle() async {
    if (isSaving) return;
    final previous = mode;
    isSaving = true;
    mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    try {
      await _repository.save(mode);
    } catch (error) {
      debugPrint('Could not save theme: $error');
      mode = previous;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
