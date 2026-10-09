import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/data/shared_preferences_task_repository.dart';
import 'package:todo_list/data/task_store.dart';
import 'package:todo_list/enums/task/task_category.dart';
import 'package:todo_list/enums/task/task_priority.dart';
import 'package:todo_list/models/todo_task.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('tasks survive save, edit, completion, and deletion', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = SharedPreferencesTaskRepository();
    final store = TaskStore(repository);
    await store.load();

    final task = TodoTask(
      id: 'test-task',
      title: 'Write a plan',
      notes: 'Keep it short',
      dueAt: DateTime(2026, 10, 10, 9),
      category: TaskCategory.work,
      priority: TaskPriority.urgent,
    );
    await store.upsert(task);
    await store.upsert(
      TodoTask(
        id: task.id,
        title: 'Write a better plan',
        notes: task.notes,
        dueAt: task.dueAt,
        category: task.category,
        priority: task.priority,
      ),
    );
    await store.toggle(task.id);

    final restored = TaskStore(repository);
    await restored.load();
    final savedTask = restored.tasks.singleWhere((item) => item.id == task.id);
    expect(savedTask.title, 'Write a better plan');
    expect(savedTask.isCompleted, isTrue);
    expect(savedTask.category, TaskCategory.work);
    expect(savedTask.priority, TaskPriority.urgent);
    expect(savedTask.dueAt, DateTime(2026, 10, 10, 9));

    await restored.delete(task.id);
    final afterDelete = TaskStore(repository);
    await afterDelete.load();
    expect(afterDelete.tasks.any((item) => item.id == task.id), isFalse);
  });
}
