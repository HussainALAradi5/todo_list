import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/enums/navigation/task_view.dart';
import 'package:todo_list/models/task_time_filter.dart';
import 'package:todo_list/models/todo_task.dart';
import 'package:todo_list/services/task_query_service.dart';
import 'package:todo_list/widgets/filters/task_time_filter_sheet.dart';

void main() {
  const query = TaskQueryService();
  final tasks = [
    TodoTask(id: 'morning', title: 'Morning', dueAt: DateTime(2026, 10, 10, 9)),
    TodoTask(
      id: 'evening',
      title: 'Evening',
      dueAt: DateTime(2026, 10, 11, 18),
    ),
    TodoTask(
      id: 'overnight',
      title: 'Overnight',
      dueAt: DateTime(2026, 10, 12, 1),
    ),
    const TodoTask(id: 'anytime', title: 'Anytime', dueAt: null),
  ];

  test('filters by day, hour, both, and across midnight', () {
    List<String> ids(TaskTimeFilter filter) => query
        .visibleTasks(tasks, view: TaskView.tasks, timeFilter: filter)
        .map((task) => task.id)
        .toList();

    expect(
      ids(
        TaskTimeFilter(
          fromDay: DateTime(2026, 10, 11),
          toDay: DateTime(2026, 10, 11),
        ),
      ),
      ['evening'],
    );
    expect(ids(const TaskTimeFilter(fromMinute: 18 * 60)), ['evening']);
    expect(
      ids(
        TaskTimeFilter(
          fromDay: DateTime(2026, 10, 11),
          toDay: DateTime(2026, 10, 12),
          fromMinute: 17 * 60,
          toMinute: 2 * 60,
        ),
      ),
      ['evening', 'overnight'],
    );
  });

  test('date filter applies within Tasks or Done, never across status', () {
    final mixed = [
      ...tasks,
      TodoTask(
        id: 'done-evening',
        title: 'Done evening',
        dueAt: DateTime(2026, 10, 11, 18),
        isCompleted: true,
      ),
    ];
    final filter = TaskTimeFilter(
      fromDay: DateTime(2026, 10, 11),
      toDay: DateTime(2026, 10, 11),
    );

    expect(
      query
          .visibleTasks(mixed, view: TaskView.tasks, timeFilter: filter)
          .map((task) => task.id),
      ['evening'],
    );
    expect(
      query
          .visibleTasks(mixed, view: TaskView.done, timeFilter: filter)
          .map((task) => task.id),
      ['done-evening'],
    );
  });

  testWidgets('Tasks filter has only date and time range controls', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date & time'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskTimeFilterSheet), findsOneWidget);
    expect(find.text('Filter tasks'), findsOneWidget);
    expect(find.text('Due today'), findsNothing);
    expect(find.text('Due tomorrow'), findsNothing);
    await tester.tap(find.text('From day'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Filtered'), findsOneWidget);
    expect(find.text('Your tasks.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Done date filter keeps completed tasks separate', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Date & time'));
    await tester.pumpAndSettle();
    expect(find.text('Filter done tasks'), findsOneWidget);
    expect(find.text('Due today'), findsNothing);
    expect(find.text('Due tomorrow'), findsNothing);
    await tester.tap(find.text('From day'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show done'));
    await tester.pumpAndSettle();
    expect(find.text('Nicely done.'), findsOneWidget);
    expect(find.text('Filtered'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter sheet fits compact landscape', (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(600, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Filter'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();
    expect(find.byType(TaskTimeFilterSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
