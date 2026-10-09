import 'package:flutter/widgets.dart';

import '../../data/theme_store.dart';

class ThemeScope extends InheritedWidget {
  const ThemeScope({super.key, required this.store, required super.child});

  final ThemeStore store;

  static ThemeStore of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ThemeScope>();
    assert(scope != null, 'ThemeScope is missing above this widget.');
    return scope!.store;
  }

  @override
  bool updateShouldNotify(ThemeScope oldWidget) => store != oldWidget.store;
}
