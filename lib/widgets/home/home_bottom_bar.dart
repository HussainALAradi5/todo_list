import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../theme/app_palette.dart';
import 'home_nav_item.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.onAdd,
  });

  final TaskView selected;
  final ValueChanged<TaskView> onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.palette.surface,
      border: Border(top: BorderSide(color: context.palette.border)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 8, 17, 7),
        child: Row(
          children: [
            Expanded(
              child: HomeNavItem(
                label: 'Tasks',
                icon: Icons.view_list_rounded,
                selected: selected == TaskView.tasks,
                onTap: () => onSelect(TaskView.tasks),
              ),
            ),
            Semantics(
              label: 'Add task',
              button: true,
              child: IconButton.filled(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: context.palette.primary,
                  foregroundColor: context.palette.background,
                  fixedSize: const Size(53, 53),
                ),
              ),
            ),
            Expanded(
              child: HomeNavItem(
                label: 'Done',
                icon: Icons.check_circle_outline_rounded,
                selected: selected == TaskView.done,
                onTap: () => onSelect(TaskView.done),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
