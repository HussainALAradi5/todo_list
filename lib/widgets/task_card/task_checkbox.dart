import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';

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
          color: isCompleted ? context.palette.primary : Colors.transparent,
          border: Border.all(
            color: isCompleted
                ? context.palette.primary
                : context.palette.checkboxBorder,
            width: 1.8,
          ),
          borderRadius: BorderRadius.circular(9),
        ),
        child: isCompleted
            ? Icon(
                Icons.check_rounded,
                size: 18,
                color: context.palette.background,
              )
            : null,
      ),
    ),
  );
}
