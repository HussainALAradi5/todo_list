import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list/controllers/home_filter_controller.dart';
import 'package:todo_list/controllers/task_action_controller.dart';
import 'package:todo_list/data/task_store.dart';
import 'package:todo_list/data/theme_store.dart';
import 'package:todo_list/interfaces/task_repository.dart';
import 'package:todo_list/interfaces/theme_repository.dart';
import 'package:todo_list/models/todo_task.dart';
import 'package:todo_list/services/task_reminder_service.dart';

void main() {
  testWidgets('search waits briefly and keeps only the latest query', (
    tester,
  ) async {
    final filters = HomeFilterController();
    addTearDown(filters.dispose);
    filters.setQuery('pl');
    filters.setQuery('plan');
    expect(filters.query, isEmpty);
    await tester.pump(const Duration(milliseconds: 159));
    expect(filters.query, isEmpty);
    await tester.pump(const Duration(milliseconds: 1));
    expect(filters.query, 'plan');

    filters.toggleSearch();
    filters.setQuery('ignored');
    filters.toggleSearch();
    await tester.pump(HomeFilterController.searchDelay);
    expect(filters.query, isEmpty);
  });

  testWidgets('repeat task taps queue only one completion', (tester) async {
    const task = TodoTask(id: 'task', title: 'Pay rent', dueAt: null);
    final repository = _DelayedTaskRepository(task);
    final store = TaskStore(repository);
    await store.load();
    final actions = TaskActionController(store, TaskReminderService());
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (value) {
              context = value;
              return const Text('Ready');
            },
          ),
        ),
      ),
    );

    final first = actions.toggle(context, task);
    final second = actions.toggle(context, task);
    await tester.pump();
    expect(repository.saveCalls, 1);
    repository.finishSave.complete();
    await Future.wait([first, second]);
    expect(store.tasks.single.isCompleted, isTrue);
    store.dispose();
  });

  testWidgets('theme ignores repeat taps while saving', (tester) async {
    final repository = _DelayedThemeRepository();
    final store = ThemeStore(repository);
    final first = store.toggle();
    final second = store.toggle();
    expect(store.mode, ThemeMode.dark);
    expect(store.isSaving, isTrue);
    expect(repository.saveCalls, 1);
    repository.finishSave.complete();
    await Future.wait([first, second]);
    expect(store.mode, ThemeMode.dark);
    expect(store.isSaving, isFalse);
    store.dispose();
  });
}

class _DelayedTaskRepository implements TaskRepository {
  _DelayedTaskRepository(this.task);
  final TodoTask task;
  final finishSave = Completer<void>();
  int saveCalls = 0;

  @override
  Future<List<TodoTask>?> load() async => [task];

  @override
  Future<void> save(List<TodoTask> tasks) {
    saveCalls++;
    return finishSave.future;
  }
}

class _DelayedThemeRepository implements ThemeRepository {
  final finishSave = Completer<void>();
  int saveCalls = 0;

  @override
  Future<ThemeMode> load() async => ThemeMode.light;

  @override
  Future<void> save(ThemeMode mode) {
    saveCalls++;
    return finishSave.future;
  }
}
