import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';

class TodoTask {
  const TodoTask({
    required this.id,
    required this.title,
    this.notes = '',
    required this.dueAt,
    this.category = TaskCategory.personal,
    this.priority = TaskPriority.normal,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String notes;
  final DateTime? dueAt;
  final TaskCategory category;
  final TaskPriority priority;
  final bool isCompleted;
}
