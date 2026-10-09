import 'package:flutter/material.dart';

import '../../enums/task/task_category.dart';
import '../../enums/task/task_priority.dart';
import '../../extensions/task_category_style.dart';
import '../../models/todo_task.dart';
import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';

class TaskMetadata extends StatelessWidget {
  const TaskMetadata({super.key, required this.task});

  final TodoTask task;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      _CategoryBadge(category: task.category),
      const Icon(Icons.schedule_rounded, size: 14, color: AppColors.muted),
      Text(
        '${dateLabel(task.dueAt, DateTime.now())}${task.dueAt == null ? '' : ' · ${timeLabel(task.dueAt, context)}'}',
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      if (task.priority == TaskPriority.high)
        const Icon(Icons.flag_rounded, color: AppColors.coral, size: 15),
    ],
  );
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final TaskCategory category;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: category.color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      category.label,
      style: TextStyle(
        color: category.color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
