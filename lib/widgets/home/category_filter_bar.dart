import 'package:flutter/material.dart';

import '../../enums/task/task_category.dart';
import '../../extensions/task_category_style.dart';
import '../../theme/app_theme.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaskCategory? selected;
  final ValueChanged<TaskCategory?> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 43,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _FilterChip(
          label: 'All',
          selected: selected == null,
          onTap: () => onChanged(null),
        ),
        for (final category in TaskCategory.values)
          _FilterChip(
            label: category.label,
            selected: selected == category,
            onTap: () => onChanged(category),
          ),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: selected ? AppColors.purple : Colors.white,
      side: BorderSide(color: selected ? AppColors.purple : AppColors.border),
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.muted,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
