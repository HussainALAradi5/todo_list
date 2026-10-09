import '../enums/navigation/task_view.dart';
import '../enums/task/task_category.dart';
import '../models/task_progress.dart';
import '../models/task_time_filter.dart';
import '../models/todo_task.dart';
import 'task_time_filter_service.dart';

class TaskQueryService {
  const TaskQueryService();

  static const _timeFilter = TaskTimeFilterService();

  List<TodoTask> visibleTasks(
    List<TodoTask> tasks, {
    required TaskView view,
    TaskCategory? category,
    String query = '',
    TaskTimeFilter? timeFilter,
  }) {
    final search = query.trim().toLowerCase();
    final results = tasks.where((task) {
      final inView = switch (view) {
        TaskView.tasks => !task.isCompleted,
        TaskView.done => task.isCompleted,
      };
      return inView &&
          _timeFilter.matches(task.dueAt, timeFilter) &&
          (category == null || task.category == category) &&
          (search.isEmpty ||
              task.title.toLowerCase().contains(search) ||
              task.notes.toLowerCase().contains(search));
    }).toList();

    results.sort((first, second) {
      if (view == TaskView.tasks && first.priority != second.priority) {
        return second.priority.index.compareTo(first.priority.index);
      }
      if (first.dueAt == null) return second.dueAt == null ? 0 : 1;
      if (second.dueAt == null) return -1;
      return first.dueAt!.compareTo(second.dueAt!);
    });
    return results;
  }

  TaskProgress progressForToday(List<TodoTask> tasks, DateTime now) {
    final today = _day(now);
    final due = tasks.where((task) => _isDueBy(task, today));
    return TaskProgress(
      total: due.length,
      completed: due.where((task) => task.isCompleted).length,
    );
  }

  DateTime _day(DateTime value) => DateTime(value.year, value.month, value.day);

  bool _isDueBy(TodoTask task, DateTime day) =>
      task.dueAt == null || !_day(task.dueAt!).isAfter(day);
}
