import 'dart:async';

import 'package:flutter/material.dart';

import '../controllers/home_filter_controller.dart';
import '../controllers/task_action_controller.dart';
import '../data/shared_preferences_task_repository.dart';
import '../data/task_store.dart';
import '../models/task_time_filter.dart';
import '../services/task_query_service.dart';
import '../services/task_reminder_service.dart';
import '../widgets/filters/task_time_filter_sheet.dart';
import '../widgets/home/home_bottom_bar.dart';
import '../widgets/home/home_content.dart';
import '../widgets/home/home_side_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskStore _store;
  late final TaskActionController _actions;
  final _filters = HomeFilterController();
  final _taskQuery = const TaskQueryService();
  final _reminders = TaskReminderService();

  @override
  void initState() {
    super.initState();
    _store = TaskStore(SharedPreferencesTaskRepository(), _reminders)
      ..addListener(_refresh);
    _actions = TaskActionController(_store, _reminders);
    _filters.addListener(_refresh);
    _store.load();
  }

  @override
  void dispose() {
    _store.removeListener(_refresh);
    _filters.removeListener(_refresh);
    _store.dispose();
    _filters.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _openTimeFilter() async {
    final filter = await showModalBottomSheet<TaskTimeFilter>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TaskTimeFilterSheet(
        view: _filters.view,
        initial: _filters.timeFilter,
      ),
    );
    if (mounted && filter != null) _filters.applyTimeFilter(filter);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tasks = _store.tasks;
    final size = MediaQuery.sizeOf(context);
    final landscape = size.width >= 600 && size.width > size.height;
    final content = HomeContent(
      view: _filters.view,
      landscape: landscape,
      tasks: _taskQuery.visibleTasks(
        tasks,
        view: _filters.view,
        category: _filters.category,
        query: _filters.query,
        timeFilter: _filters.timeFilter,
      ),
      progress: _taskQuery.progressForToday(tasks, now),
      selectedCategory: _filters.category,
      searchVisible: _filters.searchVisible,
      onSearchToggle: _filters.toggleSearch,
      onSearchChanged: _filters.setQuery,
      onCategoryChanged: _filters.setCategory,
      timeFilter: _filters.timeFilter,
      onTimeFilterOpen: _openTimeFilter,
      onTimeFilterClear: _filters.clearTimeFilter,
      onAdd: () => _actions.openEditor(context),
      onEdit: (task) => _actions.openEditor(context, task),
      onToggle: (task) => unawaited(_actions.toggle(context, task)),
      onDelete: (task) => _actions.confirmDelete(context, task),
      onSwiped: (task, direction) =>
          _actions.handleSwipe(context, task, direction),
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
                    selected: _filters.view,
                    onSelect: _filters.selectView,
                    onAdd: () => _actions.openEditor(context),
                  ),
                  Expanded(child: content),
                ],
              )
            : content,
      ),
      bottomNavigationBar: landscape
          ? null
          : HomeBottomBar(
              selected: _filters.view,
              onSelect: _filters.selectView,
              onAdd: () => _actions.openEditor(context),
            ),
    );
  }
}
