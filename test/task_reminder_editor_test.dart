import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/models/todo_task.dart';
import 'package:todo_list/screens/task_editor_screen.dart';

void main() {
  testWidgets('denied notification permission keeps editor open', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var saves = 0;
    final task = TodoTask(
      id: 'test-task',
      title: 'Pay rent',
      dueAt: DateTime.now().add(const Duration(days: 2)),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: TaskEditorScreen(
          task: task,
          onSave: (_) async {
            saves++;
          },
          requestReminderPermission: () async => false,
        ),
      ),
    );

    await tester.scrollUntilVisible(
      find.text('10 min before'),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('10 min before'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    expect(saves, 0);
    expect(
      find.text('Allow notifications or choose Reminder Off.'),
      findsOneWidget,
    );
    expect(find.byType(TaskEditorScreen), findsOneWidget);
  });
}
