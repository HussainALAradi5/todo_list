import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/shared_preferences_task_repository.dart';
import '../data/task_store.dart';
import '../enums/navigation/task_view.dart';
import '../enums/task/task_category.dart';
import '../models/todo_task.dart';
import '../services/task_query_service.dart';
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
    final result = await Navigator.of(context).push<TodoTask>(
      MaterialPageRoute(builder: (_) => TaskEditorScreen(task: task)),
    );
    if (result != null) await _store.upsert(result);
  }

  Future<void> _deleteTask(TodoTask task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete task?'),
        content: Text('“${task.title}” will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) await _store.delete(task.id);
  }

  void _selectView(TaskView view) => setState(() {
    _view = view;
    _category = null;
    _query = '';
    _showSearch = false;
  });

  void _handleSwipe(TodoTask task, DismissDirection direction) {
    final completed = direction == DismissDirection.startToEnd;
    if (completed) {
      unawaited(_store.toggle(task.id));
    } else {
      unawaited(_store.delete(task.id));
    }
    unawaited(HapticFeedback.selectionClick());

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          completed
              ? task.isCompleted
                    ? 'Task restored'
                    : 'Task completed'
              : 'Task deleted',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => unawaited(_store.upsert(task)),
        ),
      ),
    );
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
      onToggle: _store.toggle,
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
