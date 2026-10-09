import 'package:flutter/material.dart';

import '../../enums/task/task_priority.dart';
import '../../extensions/task_priority_style.dart';
import '../../theme/app_palette.dart';
import 'field_label.dart';

class TaskPriorityField extends StatelessWidget {
  const TaskPriorityField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('PRIORITY'),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final priority in TaskPriority.values)
            ChoiceChip(
              label: Text(priority.label),
              avatar: Icon(
                priority.icon,
                size: 18,
                color: priority.color(context),
              ),
              selected: value == priority,
              onSelected: (_) => onChanged(priority),
              showCheckmark: false,
              selectedColor: priority.color(context).withValues(alpha: .16),
              backgroundColor: context.palette.surface,
              side: BorderSide(
                color: value == priority
                    ? priority.color(context)
                    : context.palette.border,
              ),
              labelStyle: TextStyle(
                color: value == priority
                    ? priority.color(context)
                    : context.palette.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        value.description,
        style: TextStyle(color: context.palette.muted, fontSize: 12),
      ),
    ],
  );
}
