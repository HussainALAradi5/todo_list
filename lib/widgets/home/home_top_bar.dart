import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../utils/date_format.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.onSearch,
    required this.searchActive,
  });

  final VoidCallback onSearch;
  final bool searchActive;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.purple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 23),
      ),
      const SizedBox(width: 10),
      const Text(
        'dayly',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: AppColors.ink,
        ),
      ),
      const Spacer(),
      Text(
        longDate(DateTime.now()),
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 12),
      IconButton.filledTonal(
        tooltip: searchActive ? 'Close search' : 'Search tasks',
        onPressed: onSearch,
        icon: Icon(searchActive ? Icons.close_rounded : Icons.search_rounded),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.ink,
          fixedSize: const Size(43, 43),
        ),
      ),
    ],
  );
}
