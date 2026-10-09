import 'package:flutter/material.dart';

import '../../enums/task/task_priority.dart';
import '../../theme/app_theme.dart';
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
      SwitchListTile.adaptive(
        value: value == TaskPriority.high,
        onChanged: (selected) =>
            onChanged(selected ? TaskPriority.high : TaskPriority.normal),
        title: const Text(
          'High priority',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Keep this task at the top of the list'),
        secondary: const Icon(Icons.flag_rounded, color: AppColors.coral),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    ],
  );
}
