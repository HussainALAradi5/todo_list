import 'package:flutter/material.dart';

import '../../constants/layout_constants.dart';
import '../../enums/navigation/task_view.dart';
import '../../enums/task/task_category.dart';
import '../../models/task_progress.dart';
import '../../models/todo_task.dart';
import 'empty_task_state.dart';
import 'home_overview.dart';
import 'swipeable_task_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.view,
    required this.landscape,
    required this.tasks,
    required this.progress,
    required this.selectedCategory,
    required this.searchVisible,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onAdd,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
    required this.onSwiped,
  });

  final TaskView view;
  final bool landscape;
  final List<TodoTask> tasks;
  final TaskProgress progress;
  final TaskCategory? selectedCategory;
  final bool searchVisible;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<TaskCategory?> onCategoryChanged;
  final VoidCallback onAdd;
  final ValueChanged<TodoTask> onEdit;
  final ValueChanged<String> onToggle;
  final ValueChanged<TodoTask> onDelete;
  final void Function(TodoTask task, DismissDirection direction) onSwiped;

  @override
  Widget build(BuildContext context) {
    final overview = HomeOverview(
      view: view,
      taskCount: tasks.length,
      progress: progress,
      selectedCategory: selectedCategory,
      searchVisible: searchVisible,
      onSearchToggle: onSearchToggle,
      onSearchChanged: onSearchChanged,
      onCategoryChanged: onCategoryChanged,
    );

    if (landscape) {
      return Row(
        children: [
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              child: overview,
            ),
          ),
          VerticalDivider(width: 1, color: Theme.of(context).dividerColor),
          Expanded(
            flex: 5,
            child: CustomScrollView(
              slivers: [_taskSliver(const EdgeInsets.fromLTRB(14, 16, 20, 16))],
            ),
          ),
        ],
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: LayoutConstants.maxContentWidth,
        ),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                LayoutConstants.contentPadding,
                23,
                LayoutConstants.contentPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(child: overview),
            ),
            _taskSliver(
              const EdgeInsets.fromLTRB(
                LayoutConstants.contentPadding,
                0,
                LayoutConstants.contentPadding,
                28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _taskSliver(EdgeInsets padding) => SliverPadding(
    padding: padding,
    sliver: tasks.isEmpty
        ? SliverToBoxAdapter(
            child: EmptyTaskState(view: view, onAdd: onAdd),
          )
        : SliverList.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return SwipeableTaskCard(
                key: ValueKey(task.id),
                task: task,
                onToggle: () => onToggle(task.id),
                onEdit: () => onEdit(task),
                onDelete: () => onDelete(task),
                onSwiped: onSwiped,
              );
            },
          ),
  );
}
