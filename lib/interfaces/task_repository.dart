import '../models/todo_task.dart';

abstract interface class TaskRepository {
  /// Returns null only before the first save.
  Future<List<TodoTask>?> load();

  Future<void> save(List<TodoTask> tasks);
}
