import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/widgets/task_card/task_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('create and complete a task on a phone-sized screen', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    expect(find.text('Make today count.'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Test the new UI');
    await tester.ensureVisible(find.text('Urgent'));
    await tester.tap(find.text('Urgent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Test the new UI'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Test the new UI'), findsOneWidget);

    final newTaskCard = find.ancestor(
      of: find.text('Test the new UI'),
      matching: find.byType(TaskCard),
    );
    expect(
      find.descendant(of: newTaskCard, matching: find.text('Urgent')),
      findsOneWidget,
    );
    await tester.tap(
      find.descendant(
        of: newTaskCard,
        matching: find.bySemanticsLabel('Complete task'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Test the new UI'), findsOneWidget);
  });

  testWidgets('swipe actions can be undone', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    const taskKey = ValueKey('swipe-starter-1');
    expect(find.byKey(taskKey), findsOneWidget);

    await tester.drag(find.byKey(taskKey), const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Task completed'), findsOneWidget);
    expect(find.byKey(taskKey), findsNothing);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.byKey(taskKey), findsOneWidget);

    await tester.drag(find.byKey(taskKey), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Task deleted'), findsOneWidget);
    expect(find.byKey(taskKey), findsNothing);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.byKey(taskKey), findsOneWidget);
  });
}
