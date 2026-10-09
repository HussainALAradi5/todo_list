import 'package:flutter/foundation.dart';

import '../interfaces/task_repository.dart';
import '../interfaces/task_reminder_scheduler.dart';
import '../enums/task/task_reminder.dart';
import '../models/todo_task.dart';
import '../services/starter_task_service.dart';

class TaskStore extends ChangeNotifier {
  TaskStore(this._repository, [this._reminders]);

  final TaskRepository _repository;
  final TaskReminderScheduler? _reminders;
  final _starterTasks = const StarterTaskService();
  final List<TodoTask> _tasks = [];
  Future<void> _pendingWrite = Future.value();
  bool isLoading = true;

  List<TodoTask> get tasks => List.unmodifiable(_tasks);

  Future<void> load() async {
    try {
      final saved = await _repository.load();
      _tasks
        ..clear()
        ..addAll(saved ?? _starterTasks.create(DateTime.now()));
      if (saved == null) await _repository.save(_tasks);
    } catch (error) {
      debugPrint('Could not load tasks: $error');
      _tasks
        ..clear()
        ..addAll(_starterTasks.create(DateTime.now()));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> upsert(TodoTask task) => _commit(task.id, () {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
  });

  Future<void> toggle(String id) => _commit(id, () {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index == -1) return;
    final task = _tasks[index];
    _tasks[index] = TodoTask(
      id: task.id,
      title: task.title,
      notes: task.notes,
      dueAt: task.dueAt,
      category: task.category,
      priority: task.priority,
      isCompleted: !task.isCompleted,
      reminder: task.reminder,
    );
  });

  Future<void> delete(String id) =>
      _commit(id, () => _tasks.removeWhere((task) => task.id == id));

  Future<void> _commit(String id, void Function() change) {
    final operation = _pendingWrite.then((_) async {
      final previous = List<TodoTask>.of(_tasks);
      final oldIndex = previous.indexWhere((task) => task.id == id);
      final oldTask = oldIndex < 0 ? null : previous[oldIndex];
      change();
      notifyListeners();
      try {
        await _repository.save(_tasks);
      } catch (error) {
        _tasks
          ..clear()
          ..addAll(previous);
        notifyListeners();
        debugPrint('Could not save tasks: $error');
        rethrow;
      }
      final index = _tasks.indexWhere((task) => task.id == id);
      final current = index < 0 ? null : _tasks[index];
      if (_reminders != null &&
          ((oldTask?.reminder ?? TaskReminder.none) != TaskReminder.none ||
              (current?.reminder ?? TaskReminder.none) != TaskReminder.none)) {
        try {
          if (current == null) {
            await _reminders.cancel(id);
          } else {
            await _reminders.sync(current);
          }
        } catch (error) {
          debugPrint('Could not update task reminder: $error');
        }
      }
    });
    _pendingWrite = operation.then<void>((_) {}, onError: (Object _) {});
    return operation;
  }
}
