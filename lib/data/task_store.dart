import 'package:flutter/foundation.dart';

import '../interfaces/task_repository.dart';
import '../models/todo_task.dart';
import '../services/starter_task_service.dart';

class TaskStore extends ChangeNotifier {
  TaskStore(this._repository);

  final TaskRepository _repository;
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

  Future<void> upsert(TodoTask task) => _commit(() {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _tasks.add(task);
    } else {
      _tasks[index] = task;
    }
  });

  Future<void> toggle(String id) => _commit(() {
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
    );
  });

  Future<void> delete(String id) =>
      _commit(() => _tasks.removeWhere((task) => task.id == id));

  Future<void> _commit(void Function() change) {
    final operation = _pendingWrite.then((_) async {
      final previous = List<TodoTask>.of(_tasks);
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
    });
    _pendingWrite = operation.then<void>((_) {}, onError: (Object _) {});
    return operation;
  }
}
