import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class TaskCheckbox extends StatelessWidget {
  const TaskCheckbox({
    super.key,
    required this.isCompleted,
    required this.onTap,
  });

  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    label: isCompleted ? 'Mark incomplete' : 'Complete task',
    button: true,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 25,
        height: 25,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.purple : Colors.transparent,
          border: Border.all(
            color: isCompleted ? AppColors.purple : const Color(0xFFCED2DC),
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: isCompleted
            ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
            : null,
      ),
    ),
  );
}
