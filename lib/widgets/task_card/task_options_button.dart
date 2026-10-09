import 'package:flutter/material.dart';

import '../../enums/task/task_action.dart';
import '../../theme/app_palette.dart';

class TaskOptionsButton extends StatelessWidget {
  const TaskOptionsButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => PopupMenuButton<TaskAction>(
    icon: Icon(Icons.more_horiz_rounded, color: context.palette.muted),
    tooltip: 'Task options',
    onSelected: (action) => switch (action) {
      TaskAction.edit => onEdit(),
      TaskAction.delete => onDelete(),
    },
    itemBuilder: (context) => const [
      PopupMenuItem(value: TaskAction.edit, child: Text('Edit')),
      PopupMenuItem(value: TaskAction.delete, child: Text('Delete')),
    ],
  );
}
