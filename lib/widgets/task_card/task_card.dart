import 'package:flutter/material.dart';

import '../../constants/layout_constants.dart';
import '../../models/todo_task.dart';
import '../../theme/app_palette.dart';
import 'task_checkbox.dart';
import 'task_metadata.dart';
import 'task_options_button.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onDelete,
  });

  final TodoTask task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: LayoutConstants.taskSpacing),
    decoration: BoxDecoration(
      color: context.palette.surface,
      borderRadius: BorderRadius.circular(LayoutConstants.taskRadius),
      border: Border.all(color: context.palette.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080E1935),
          blurRadius: 16,
          offset: Offset(0, 7),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(LayoutConstants.taskRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 16, 8, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskCheckbox(isCompleted: task.isCompleted, onTap: onToggle),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: task.isCompleted
                            ? context.palette.muted
                            : context.palette.ink,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (task.notes.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.palette.muted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                    const SizedBox(height: 13),
                    TaskMetadata(task: task),
                  ],
                ),
              ),
              TaskOptionsButton(onEdit: onTap, onDelete: onDelete),
            ],
          ),
        ),
      ),
    ),
  );
}
