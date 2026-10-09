import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../enums/task/task_category.dart';
import '../../extensions/task_progress_values.dart';
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
        TaskView.all => 'Everything in view.',
        TaskView.today => 'Make today count.',
        TaskView.upcoming => 'Coming up.',
        TaskView.completed => 'Nicely done.',
      }, style: Theme.of(context).textTheme.headlineLarge),
      const SizedBox(height: 6),
      Text(switch (view) {
        TaskView.all => 'Find what needs your attention.',
        TaskView.today =>
          progress.remaining == 0
              ? 'You’re all caught up for today.'
              : '${progress.remaining} task${progress.remaining == 1 ? '' : 's'} on your plate today.',
        TaskView.upcoming => 'A clear view of what’s ahead.',
        TaskView.completed => 'Every small step adds up.',
      }, style: TextStyle(color: context.palette.muted, fontSize: 15)),
      if (view == TaskView.today) ...[
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
                TaskView.all => 'All tasks',
                TaskView.today => 'Your tasks',
                TaskView.upcoming => 'Upcoming tasks',
                TaskView.completed => 'Completed tasks',
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
        TaskView.completed => 'Swipe right to restore · left to delete',
        TaskView.all => 'Swipe right to finish or restore · left to delete',
        _ => 'Swipe right to finish · left to delete',
      }, style: TextStyle(color: context.palette.muted, fontSize: 11)),
      const SizedBox(height: 17),
    ],
  );
}
