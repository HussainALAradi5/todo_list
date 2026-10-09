import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/data/task_store.dart';
import 'package:todo_list/enums/task/task_reminder.dart';
import 'package:todo_list/interfaces/task_reminder_scheduler.dart';
import 'package:todo_list/interfaces/task_repository.dart';
import 'package:todo_list/models/todo_task.dart';
import 'package:todo_list/utils/task_notification_id.dart';

void main() {
  test('task changes schedule, cancel, and restore reminders', () async {
    final reminders = _RecordingReminders();
    final store = TaskStore(_MemoryRepository(), reminders);
    await store.load();
    final task = TodoTask(
      id: 'reminded-task',
      title: 'Pay rent',
      dueAt: DateTime(2030, 1, 1),
      reminder: TaskReminder.oneDayBefore,
    );

    await store.upsert(task);
    expect(reminders.synced.last.reminder, TaskReminder.oneDayBefore);
    await store.toggle(task.id);
    expect(reminders.synced.last.isCompleted, isTrue);
    await store.toggle(task.id);
    expect(reminders.synced.last.isCompleted, isFalse);
    await store.delete(task.id);
    expect(reminders.cancelled, [task.id]);
  });

  test('notification IDs stay stable for a task', () {
    expect(taskNotificationId('my-task'), taskNotificationId('my-task'));
    expect(taskNotificationId('my-task'), isNot(taskNotificationId('other')));
  });
}

class _MemoryRepository implements TaskRepository {
  List<TodoTask> tasks = [];

  @override
  Future<List<TodoTask>?> load() async => tasks;

  @override
  Future<void> save(List<TodoTask> tasks) async {
    this.tasks = List.of(tasks);
  }
}

class _RecordingReminders implements TaskReminderScheduler {
  final synced = <TodoTask>[];
  final cancelled = <String>[];

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> sync(TodoTask task) async => synced.add(task);

  @override
  Future<void> cancel(String taskId) async => cancelled.add(taskId);
}
