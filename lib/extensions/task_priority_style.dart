import 'package:flutter/material.dart';

import '../enums/task/task_priority.dart';
import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

extension TaskPriorityStyle on TaskPriority {
  String get label => switch (this) {
    TaskPriority.normal => 'Normal',
    TaskPriority.high => 'High',
    TaskPriority.urgent => 'Urgent',
  };

  String get description => switch (this) {
    TaskPriority.normal => 'A regular task',
    TaskPriority.high => 'Keep near the top',
    TaskPriority.urgent => 'Needs attention first',
  };

  IconData get icon => switch (this) {
    TaskPriority.normal => Icons.remove_rounded,
    TaskPriority.high => Icons.flag_outlined,
    TaskPriority.urgent => Icons.priority_high_rounded,
  };

  Color color(BuildContext context) => switch (this) {
    TaskPriority.normal => context.palette.primary,
    TaskPriority.high => AppColors.coral,
    TaskPriority.urgent =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFFF8A8A)
          : const Color(0xFFCB3444),
  };
}
