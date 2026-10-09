import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/widgets/home/home_bottom_bar.dart';
import 'package:todo_list/widgets/home/home_side_bar.dart';
import 'package:todo_list/widgets/task_card/task_card.dart';
import 'package:todo_list/widgets/task_editor/task_editor_layout.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('dashboard and editor work while rotating the phone', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomeSideBar), findsOneWidget);
    expect(find.byType(HomeBottomBar), findsNothing);
    expect(find.byType(TaskCard), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip('Add task'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskEditorLayout), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Landscape task');
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('Create task'), findsOneWidget);
    expect(find.text('Landscape task'), findsOneWidget);
    tester.view.viewInsets = const FakeViewPadding(bottom: 500);
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
    expect(tester.takeException(), isNull);
    tester.view.resetViewInsets();
    tester.view.physicalSize = const Size(844, 390);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeSideBar), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byType(HomeBottomBar), findsOneWidget);
    expect(find.byType(HomeSideBar), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact landscape phone has accessible navigation and tasks', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(667, 375);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.byType(HomeSideBar), findsOneWidget);
    expect(find.byType(TaskCard), findsWidgets);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(600, 300);
    await tester.pumpAndSettle();
    expect(find.byType(HomeSideBar), findsOneWidget);
    expect(find.byType(TaskCard), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
