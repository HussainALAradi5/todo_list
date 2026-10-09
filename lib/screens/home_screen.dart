import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/shared_preferences_task_repository.dart';
import '../data/task_store.dart';
import '../enums/navigation/task_view.dart';
import '../enums/task/task_category.dart';
import '../models/todo_task.dart';
import '../services/task_feedback_service.dart';
import '../services/task_query_service.dart';
import '../widgets/dialogs/task_delete_dialog.dart';
import '../widgets/home/home_bottom_bar.dart';
import '../widgets/home/home_content.dart';
import '../widgets/home/home_side_bar.dart';
import 'task_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskStore _store;
  final _taskQuery = const TaskQueryService();
  final _feedback = const TaskFeedbackService();
  TaskView _view = TaskView.today;
  TaskCategory? _category;
  bool _showSearch = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _store = TaskStore(SharedPreferencesTaskRepository())
      ..addListener(_refresh);
    _store.load();
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    _store.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _openEditor([TodoTask? task]) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(task: task, onSave: _store.upsert),
      ),
    );
    if (saved != true || !mounted) return;
    _feedback.show(
      context,
      message: task == null ? 'Task created' : 'Changes saved',
      icon: Icons.check_circle_outline_rounded,
    );
  }

  Future<void> _deleteTask(TodoTask task) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => TaskDeleteDialog(
        title: task.title,
        onDelete: () => _store.delete(task.id),
      ),
    );
    if (deleted == true) _showDeleted(task);
  }

  Future<void> _toggleTask(TodoTask task) async {
    try {
      await _store.toggle(task.id);
    } catch (_) {
      _showWriteError('Could not update task. Try again.');
      return;
    }
    if (!mounted) return;
    _feedback.show(
      context,
      message: task.isCompleted ? 'Task restored' : 'Task completed',
      icon: task.isCompleted ? Icons.restore_rounded : Icons.task_alt_rounded,
      onUndo: () => unawaited(_restoreTask(task)),
    );
  }

  Future<void> _removeTask(TodoTask task) async {
    try {
      await _store.delete(task.id);
    } catch (_) {
      _showWriteError('Could not delete task. Try again.');
      return;
    }
    _showDeleted(task);
  }

  Future<void> _restoreTask(TodoTask task) async {
    try {
      await _store.upsert(task);
    } catch (_) {
      _showWriteError('Could not restore task. Try again.');
    }
  }

  void _showWriteError(String message) {
    if (!mounted) return;
    _feedback.show(
      context,
      message: message,
      icon: Icons.error_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
    );
  }

  void _showDeleted(TodoTask task) {
    if (!mounted) return;
    _feedback.show(
      context,
      message: 'Task deleted',
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      onUndo: () => unawaited(_restoreTask(task)),
    );
  }

  void _selectView(TaskView view) => setState(() {
    _view = view;
    _category = null;
    _query = '';
    _showSearch = false;
  });

  void _handleSwipe(TodoTask task, DismissDirection direction) {
    unawaited(
      direction == DismissDirection.startToEnd
          ? _toggleTask(task)
          : _removeTask(task),
    );
    unawaited(HapticFeedback.selectionClick());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width >= 600 && size.width > size.height;
    final content = HomeContent(
      view: _view,
      landscape: landscape,
      tasks: _taskQuery.visibleTasks(
        _store.tasks,
        view: _view,
        now: now,
        category: _category,
        query: _query,
      ),
      progress: _taskQuery.progressForToday(_store.tasks, now),
      selectedCategory: _category,
      searchVisible: _showSearch,
      onSearchToggle: () => setState(() {
        _showSearch = !_showSearch;
        if (!_showSearch) _query = '';
      }),
      onSearchChanged: (value) => setState(() => _query = value),
      onCategoryChanged: (category) => setState(() => _category = category),
      onAdd: () => _openEditor(),
      onEdit: _openEditor,
      onToggle: (task) => unawaited(_toggleTask(task)),
      onDelete: _deleteTask,
      onSwiped: _handleSwipe,
    );
    return Scaffold(
      body: SafeArea(
        bottom: landscape,
        child: _store.isLoading
            ? const Center(child: CircularProgressIndicator())
            : landscape
            ? Row(
                children: [
                  HomeSideBar(
                    selected: _view,
                    onSelect: _selectView,
                    onAdd: () => _openEditor(),
                  ),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
      bottomNavigationBar: landscape
          ? null
          : HomeBottomBar(
              selected: _view,
              onSelect: _selectView,
              onAdd: () => _openEditor(),
            ),
    );
  }
}
