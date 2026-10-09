import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../enums/task/task_category.dart';
import '../../models/task_progress.dart';
import '../../models/task_time_filter.dart';
import '../../theme/app_palette.dart';
import '../filters/task_time_filter_bar.dart';
import 'category_filter_bar.dart';
import 'home_top_bar.dart';
import 'progress_card.dart';

class HomeOverview extends StatelessWidget {
  const HomeOverview({
    super.key,
    required this.view,
    required this.taskCount,
    required this.progress,
    required this.selectedCategory,
    required this.searchVisible,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.timeFilter,
    required this.onTimeFilterOpen,
    required this.onTimeFilterClear,
  });

  final TaskView view;
  final int taskCount;
  final TaskProgress progress;
  final TaskCategory? selectedCategory;
  final bool searchVisible;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<TaskCategory?> onCategoryChanged;
  final TaskTimeFilter? timeFilter;
  final VoidCallback onTimeFilterOpen;
  final VoidCallback onTimeFilterClear;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeTopBar(onSearch: onSearchToggle, searchActive: searchVisible),
      const SizedBox(height: 32),
      Text(switch (view) {
        TaskView.tasks => 'Your tasks.',
        TaskView.done => 'Nicely done.',
      }, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 6),
      Text(switch (view) {
        TaskView.tasks => 'Everything you’re working on, in one place.',
        TaskView.done => 'Every small step adds up.',
      }, style: TextStyle(color: context.palette.muted, fontSize: 15)),
      if (view == TaskView.tasks && progress.total > 0) ...[
        const SizedBox(height: 27),
        ProgressCard(progress: progress),
      ],
      if (searchVisible) ...[
        const SizedBox(height: 24),
        TextField(
          autofocus: true,
          onChanged: onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search tasks',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
      ],
      const SizedBox(height: 32),
      Row(
        children: [
          Expanded(
            child: Text(
              switch (view) {
                TaskView.tasks => 'Tasks in progress',
                TaskView.done => 'Completed tasks',
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
            style: TextStyle(
              color: context.palette.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 17),
      CategoryFilterBar(
        selected: selectedCategory,
        onChanged: onCategoryChanged,
      ),
      const SizedBox(height: 8),
      TaskTimeFilterBar(
        filter: timeFilter,
        onOpen: onTimeFilterOpen,
        onClear: onTimeFilterClear,
      ),
      const SizedBox(height: 8),
      Text(switch (view) {
        TaskView.done => 'Swipe right to restore · left to delete',
        TaskView.tasks => 'Swipe right to finish · left to delete',
      }, style: TextStyle(color: context.palette.muted, fontSize: 11)),
      const SizedBox(height: 17),
    ],
  );
}
