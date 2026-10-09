import '../models/todo_task.dart';

abstract interface class TaskReminderScheduler {
  Future<bool> requestPermission();
  Future<void> sync(TodoTask task);
  Future<void> cancel(String taskId);
}
