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
                label: 'All',
                icon: Icons.view_list_rounded,
                selected: selected == TaskView.all,
                onTap: () => onSelect(TaskView.all),
              ),
              const SizedBox(height: 7),
              HomeNavItem(
                label: 'Today',
                icon: Icons.today_rounded,
                selected: selected == TaskView.today,
                onTap: () => onSelect(TaskView.today),
              ),
              const SizedBox(height: 7),
              HomeNavItem(
                label: 'Upcoming',
                icon: Icons.calendar_month_outlined,
                selected: selected == TaskView.upcoming,
                onTap: () => onSelect(TaskView.upcoming),
              ),
              const SizedBox(height: 7),
              HomeNavItem(
                label: 'Done',
                icon: Icons.check_circle_outline_rounded,
                selected: selected == TaskView.completed,
                onTap: () => onSelect(TaskView.completed),
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
