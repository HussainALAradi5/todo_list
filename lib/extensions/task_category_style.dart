import 'package:flutter/material.dart';

import '../enums/task/task_category.dart';
import '../theme/app_theme.dart';

extension TaskCategoryStyle on TaskCategory {
  String get label => switch (this) {
    TaskCategory.work => 'Work',
    TaskCategory.personal => 'Personal',
    TaskCategory.wellness => 'Wellness',
  };

  IconData get icon => switch (this) {
    TaskCategory.work => Icons.work_outline_rounded,
    TaskCategory.personal => Icons.auto_awesome_outlined,
    TaskCategory.wellness => Icons.favorite_outline_rounded,
  };

  Color get color => switch (this) {
    TaskCategory.work => AppColors.purple,
    TaskCategory.personal => AppColors.coral,
    TaskCategory.wellness => AppColors.mint,
  };
}
