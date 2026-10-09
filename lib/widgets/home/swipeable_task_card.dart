import 'package:flutter/material.dart';

import '../../constants/layout_constants.dart';
import '../../models/todo_task.dart';
import '../../theme/app_theme.dart';
import '../task_card/task_card.dart';

class SwipeableTaskCard extends StatelessWidget {
  const SwipeableTaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    required this.onSwiped,
  });

  final TodoTask task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(TodoTask task, DismissDirection direction) onSwiped;

  @override
  Widget build(BuildContext context) => Dismissible(
    key: ValueKey('swipe-${task.id}'),
    background: _SwipeBackground(
      color: AppColors.mint,
      icon: task.isCompleted ? Icons.undo_rounded : Icons.check_rounded,
      label: task.isCompleted ? 'Restore' : 'Done',
      alignment: Alignment.centerLeft,
    ),
    secondaryBackground: const _SwipeBackground(
      color: AppColors.coral,
      icon: Icons.delete_outline_rounded,
      label: 'Delete',
      alignment: Alignment.centerRight,
    ),
    onDismissed: (direction) => onSwiped(task, direction),
    child: TaskCard(
      task: task,
      onToggle: onToggle,
      onTap: onEdit,
      onDelete: onDelete,
    ),
  );
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.color,
    required this.icon,
    required this.label,
    required this.alignment,
  });

  final Color color;
  final IconData icon;
  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: LayoutConstants.taskSpacing),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    alignment: alignment,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(LayoutConstants.taskRadius),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment == Alignment.centerLeft
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Icon(icon, color: Colors.white),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
