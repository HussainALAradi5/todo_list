import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../theme/app_theme.dart';
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
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 8, 17, 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeNavItem(
              label: 'Today',
              icon: Icons.today_rounded,
              selected: selected == TaskView.today,
              onTap: () => onSelect(TaskView.today),
            ),
            HomeNavItem(
              label: 'Upcoming',
              icon: Icons.calendar_month_outlined,
              selected: selected == TaskView.upcoming,
              onTap: () => onSelect(TaskView.upcoming),
            ),
            Semantics(
              label: 'Add task',
              button: true,
              child: IconButton.filled(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.purple,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(53, 53),
                ),
              ),
            ),
            HomeNavItem(
              label: 'Done',
              icon: Icons.check_circle_outline_rounded,
              selected: selected == TaskView.completed,
              onTap: () => onSelect(TaskView.completed),
            ),
          ],
        ),
      ),
    ),
  );
}
