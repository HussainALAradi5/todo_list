import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/enums/navigation/task_view.dart';
import 'package:todo_list/enums/task/task_category.dart';
import 'package:todo_list/enums/task/task_priority.dart';
import 'package:todo_list/extensions/task_progress_values.dart';
import 'package:todo_list/models/todo_task.dart';
import 'package:todo_list/services/task_query_service.dart';

void main() {
  const service = TaskQueryService();
  final now = DateTime(2026, 10, 9, 14);

  TodoTask task(
    String id, {
    DateTime? dueAt,
    bool completed = false,
    TaskPriority priority = TaskPriority.normal,
    TaskCategory category = TaskCategory.personal,
  }) => TodoTask(
    id: id,
    title: id,
    dueAt: dueAt,
    isCompleted: completed,
    priority: priority,
    category: category,
  );

  test('tasks includes all unfinished dates; done contains completed', () {
    final tasks = [
      task('anytime'),
      task('overdue', dueAt: DateTime(2026, 10, 8)),
      task('today', dueAt: DateTime(2026, 10, 9, 18)),
      task('tomorrow', dueAt: DateTime(2026, 10, 10)),
      task('done', dueAt: DateTime(2026, 10, 9), completed: true),
    ];

    expect(
      service.visibleTasks(tasks, view: TaskView.tasks).map((item) => item.id),
      ['overdue', 'today', 'tomorrow', 'anytime'],
    );
    expect(
      service.visibleTasks(tasks, view: TaskView.done).map((item) => item.id),
      ['done'],
    );
    final progress = service.progressForToday(tasks, now);
    expect(progress.total, 4);
    expect(progress.completed, 1);
    expect(progress.remaining, 3);
    expect(progress.fraction, .25);
  });

  test('filters by category and sorts urgent, high, then normal', () {
    final tasks = [
      task('Call home', category: TaskCategory.personal),
      task('Write report', category: TaskCategory.work),
      task(
        'Review report',
        category: TaskCategory.work,
        priority: TaskPriority.high,
      ),
      task(
        'Send report',
        category: TaskCategory.work,
        priority: TaskPriority.urgent,
      ),
    ];

    expect(
      service
          .visibleTasks(
            tasks,
            view: TaskView.tasks,
            category: TaskCategory.work,
            query: ' REPORT ',
          )
          .map((item) => item.id),
      ['Send report', 'Review report', 'Write report'],
    );
  });

  test('sorts matching priorities by due date', () {
    final tasks = [
      task(
        'later',
        dueAt: DateTime(2026, 10, 9, 18),
        priority: TaskPriority.urgent,
      ),
      task('normal', dueAt: DateTime(2026, 10, 9, 8)),
      task(
        'sooner',
        dueAt: DateTime(2026, 10, 9, 9),
        priority: TaskPriority.urgent,
      ),
    ];

    expect(
      service.visibleTasks(tasks, view: TaskView.tasks).map((item) => item.id),
      ['sooner', 'later', 'normal'],
    );
  });
}
