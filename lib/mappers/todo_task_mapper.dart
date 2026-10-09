import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';
import '../enums/task/task_reminder.dart';
import '../models/todo_task.dart';

class TodoTaskMapper {
  const TodoTaskMapper._();

  static Map<String, dynamic> toJson(TodoTask task) => {
    'id': task.id,
    'title': task.title,
    'notes': task.notes,
    'dueAt': task.dueAt?.toIso8601String(),
    'category': task.category.name,
    'priority': task.priority.name,
    'isCompleted': task.isCompleted,
    'reminder': task.reminder.name,
  };

  static TodoTask fromJson(Map<String, dynamic> json) => TodoTask(
    id: json['id'] as String,
    title: json['title'] as String,
    notes: json['notes'] as String? ?? '',
    dueAt: DateTime.tryParse(json['dueAt'] as String? ?? ''),
    category: TaskCategory.values.byName(
      json['category'] as String? ?? TaskCategory.personal.name,
    ),
    priority: TaskPriority.values.byName(
      json['priority'] as String? ?? TaskPriority.normal.name,
    ),
    isCompleted: json['isCompleted'] as bool? ?? false,
    reminder: TaskReminder.values.firstWhere(
      (value) => value.name == json['reminder'],
      orElse: () => TaskReminder.none,
    ),
  );
}
