import 'package:flutter/material.dart';

import '../../enums/task/task_category.dart';
import '../../extensions/task_category_style.dart';
import '../../theme/app_theme.dart';
import 'field_label.dart';

class TaskCategoryField extends StatelessWidget {
  const TaskCategoryField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TaskCategory value;
  final ValueChanged<TaskCategory> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('CATEGORY'),
      const SizedBox(height: 12),
      Wrap(
        spacing: 9,
        runSpacing: 9,
        children: TaskCategory.values.map((category) {
          final selected = category == value;
          return ChoiceChip(
            label: Text(category.label),
            avatar: Icon(
              category.icon,
              size: 17,
              color: selected ? Colors.white : category.color,
            ),
            selected: selected,
            onSelected: (_) => onChanged(category),
            selectedColor: AppColors.purple,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: selected ? AppColors.purple : AppColors.border,
            ),
            showCheckmark: false,
          );
        }).toList(),
      ),
    ],
  );
}
