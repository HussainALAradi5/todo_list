import 'package:flutter/material.dart';

import 'data/shared_preferences_theme_repository.dart';
import 'data/theme_store.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/theme/theme_scope.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  late final ThemeStore _themeStore;

  @override
  void initState() {
    super.initState();
    _themeStore = ThemeStore(SharedPreferencesThemeRepository());
    _themeStore.load();
  }

  @override
  void dispose() {
    _themeStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      store: _themeStore,
      child: ListenableBuilder(
        listenable: _themeStore,
        builder: (context, child) => MaterialApp(
          title: 'Dayly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: _themeStore.mode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
