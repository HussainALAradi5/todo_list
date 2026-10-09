import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/constants/storage_keys.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/theme/app_palette.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('theme button toggles and saves dark and light modes', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to dark mode'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);
    expect(
      Theme.of(tester.element(find.byType(HomeScreen))).scaffoldBackgroundColor,
      AppPalette.dark.background,
    );
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(StorageKeys.themeMode), 'dark');

    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to light mode'), findsOneWidget);

    await tester.tap(find.byTooltip('Switch to light mode'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Switch to dark mode'), findsOneWidget);
    expect(preferences.getString(StorageKeys.themeMode), 'light');
  });
}
