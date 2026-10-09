import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../theme/app_palette.dart';

class EmptyTaskState extends StatelessWidget {
  const EmptyTaskState({super.key, required this.view, required this.onAdd});

  final TaskView view;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 38),
    decoration: BoxDecoration(
      color: context.palette.surface,
      border: Border.all(color: context.palette.border),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: context.palette.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.task_alt_rounded,
            color: context.palette.primary,
            size: 31,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          view == TaskView.completed
              ? 'Nothing completed yet'
              : 'All clear here',
          style: TextStyle(
            color: context.palette.ink,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'A little space for what matters next.',
          textAlign: TextAlign.center,
          style: TextStyle(color: context.palette.muted),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add a task'),
        ),
      ],
    ),
  );
}
