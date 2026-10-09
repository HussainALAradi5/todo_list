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
  final now = DateTime(2026, 10, 10);
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
        .visibleTasks(tasks, view: TaskView.all, now: now, timeFilter: filter)
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

  testWidgets('filter sheet applies a quick day on a phone', (tester) async {
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
    await tester.tap(find.text('Today').last);
    await tester.tap(find.text('Show tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Filtered'), findsOneWidget);
    expect(find.text('Everything in view.'), findsOneWidget);
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
