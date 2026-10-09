import 'package:flutter/material.dart';

import '../../enums/task/task_priority.dart';
import '../../extensions/task_priority_style.dart';

class TaskPriorityBadge extends StatelessWidget {
  const TaskPriorityBadge({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: priority.color(context).withValues(alpha: .12),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(priority.icon, size: 13, color: priority.color(context)),
        const SizedBox(width: 3),
        Text(
          priority.label,
          style: TextStyle(
            color: priority.color(context),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}
