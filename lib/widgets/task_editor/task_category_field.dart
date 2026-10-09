import 'package:flutter/material.dart';

import '../../enums/task/task_category.dart';
import '../../extensions/task_category_style.dart';
import '../../theme/app_palette.dart';
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
              color: selected
                  ? context.palette.background
                  : category.color(context),
            ),
            selected: selected,
            onSelected: (_) => onChanged(category),
            selectedColor: context.palette.primary,
            backgroundColor: context.palette.surface,
            labelStyle: TextStyle(
              color: selected
                  ? context.palette.background
                  : context.palette.ink,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: selected
                  ? context.palette.primary
                  : context.palette.border,
            ),
            showCheckmark: false,
          );
        }).toList(),
      ),
    ],
  );
}
