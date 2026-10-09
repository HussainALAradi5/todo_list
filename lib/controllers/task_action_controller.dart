import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/task_store.dart';
import '../interfaces/task_reminder_scheduler.dart';
import '../models/todo_task.dart';
import '../services/task_feedback_service.dart';
import '../widgets/dialogs/task_delete_dialog.dart';
import '../screens/task_editor_screen.dart';

class TaskActionController {
  TaskActionController(this._store, this._reminders);

  final TaskStore _store;
  final TaskReminderScheduler _reminders;
  final _feedback = const TaskFeedbackService();
  final Set<String> _pendingTasks = {};

  Future<void> openEditor(BuildContext context, [TodoTask? task]) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(
          task: task,
          onSave: _store.upsert,
          requestReminderPermission: _reminders.requestPermission,
        ),
      ),
    );
    if (saved != true || !context.mounted) return;
    _feedback.show(
      context,
      message: task == null ? 'Task created' : 'Changes saved',
      icon: Icons.check_circle_outline_rounded,
    );
  }

  Future<void> confirmDelete(BuildContext context, TodoTask task) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TaskDeleteDialog(
        title: task.title,
        onDelete: () => _store.delete(task.id),
      ),
    );
    if (deleted == true && context.mounted) _showDeleted(context, task);
  }

  Future<void> toggle(BuildContext context, TodoTask task) async {
    if (!_pendingTasks.add(task.id)) return;
    try {
      await _store.toggle(task.id);
    } catch (_) {
      if (!context.mounted) return;
      _showWriteError(context, 'Could not update task. Try again.');
      return;
    } finally {
      _pendingTasks.remove(task.id);
    }
    if (!context.mounted) return;
    _feedback.show(
      context,
      message: task.isCompleted ? 'Task restored' : 'Task completed',
      icon: task.isCompleted ? Icons.restore_rounded : Icons.task_alt_rounded,
      onUndo: () => unawaited(_restore(context, task)),
    );
  }

  Future<void> remove(BuildContext context, TodoTask task) async {
    if (!_pendingTasks.add(task.id)) return;
    try {
      await _store.delete(task.id);
    } catch (_) {
      if (!context.mounted) return;
      _showWriteError(context, 'Could not delete task. Try again.');
      return;
    } finally {
      _pendingTasks.remove(task.id);
    }
    if (!context.mounted) return;
    _showDeleted(context, task);
  }

  void handleSwipe(
    BuildContext context,
    TodoTask task,
    DismissDirection direction,
  ) {
    unawaited(
      direction == DismissDirection.startToEnd
          ? toggle(context, task)
          : remove(context, task),
    );
    unawaited(HapticFeedback.selectionClick());
  }

  Future<void> _restore(BuildContext context, TodoTask task) async {
    try {
      await _store.upsert(task);
    } catch (_) {
      if (!context.mounted) return;
      _showWriteError(context, 'Could not restore task. Try again.');
    }
  }

  void _showDeleted(BuildContext context, TodoTask task) {
    if (!context.mounted) return;
    _feedback.show(
      context,
      message: 'Task deleted',
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      onUndo: () => unawaited(_restore(context, task)),
    );
  }

  void _showWriteError(BuildContext context, String message) {
    if (!context.mounted) return;
    _feedback.show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }
}
