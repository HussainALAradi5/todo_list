import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../theme/app_palette.dart';
import 'home_nav_item.dart';

class HomeSideBar extends StatelessWidget {
  const HomeSideBar({
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
    width: 80,
    decoration: BoxDecoration(
      color: context.palette.surface,
      border: Border(right: BorderSide(color: context.palette.border)),
    ),
    child: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeNavItem(
                label: 'Tasks',
                icon: Icons.view_list_rounded,
                selected: selected == TaskView.tasks,
                onTap: () => onSelect(TaskView.tasks),
              ),
              const SizedBox(height: 7),
              HomeNavItem(
                label: 'Done',
                icon: Icons.check_circle_outline_rounded,
                selected: selected == TaskView.done,
                onTap: () => onSelect(TaskView.done),
              ),
              const SizedBox(height: 18),
              IconButton.filled(
                tooltip: 'Add task',
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: context.palette.primary,
                  foregroundColor: context.palette.background,
                  fixedSize: const Size(48, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
