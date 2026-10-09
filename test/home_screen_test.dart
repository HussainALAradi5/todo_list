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
    expect(find.text('Task created'), findsOneWidget);
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
    expect(find.text('Task completed'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Test the new UI'), findsOneWidget);

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
    await tester.tap(find.bySemanticsLabel('Mark incomplete').last);
    await tester.pumpAndSettle();
    expect(find.text('Task restored'), findsOneWidget);
  });

  testWidgets('edit and confirmed delete show feedback with Undo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add_rounded).first);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'Review this task',
    );
    await tester.tap(find.text('Create task'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Review this task'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review this task'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Updated task');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Changes saved'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Updated task'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -250),
    );
    await tester.pumpAndSettle();
    final card = find.ancestor(
      of: find.text('Updated task'),
      matching: find.byType(TaskCard),
    );
    await tester.tap(
      find.descendant(of: card, matching: find.byTooltip('Task options')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Delete task?'), findsOneWidget);
    expect(find.text('Updated task'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Updated task'), findsOneWidget);
    expect(find.text('Task deleted'), findsNothing);

    await tester.tap(
      find.descendant(of: card, matching: find.byTooltip('Task options')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Task deleted'), findsOneWidget);
    expect(find.text('Updated task'), findsNothing);
    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Updated task'), findsOneWidget);
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
