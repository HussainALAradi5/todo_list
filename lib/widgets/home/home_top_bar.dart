import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';
import '../../utils/date_format.dart';
import '../theme/theme_scope.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.onSearch,
    required this.searchActive,
  });

  final VoidCallback onSearch;
  final bool searchActive;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final palette = context.palette;
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final themeStore = ThemeScope.of(context);
      final compact = constraints.maxWidth < 280;
      return Row(
        children: [
          if (!compact) ...[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: palette.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.check_rounded,
                color: palette.background,
                size: 23,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              'dayly',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: compact ? 21 : 23,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
                color: palette.ink,
              ),
            ),
          ),
          if (constraints.maxWidth >= 360) ...[
            Text(
              longDate(DateTime.now()),
              style: TextStyle(
                color: palette.muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton.filledTonal(
            tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
            onPressed: themeStore.isSaving
                ? null
                : () => unawaited(themeStore.toggle()),
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            style: IconButton.styleFrom(
              backgroundColor: palette.surface,
              foregroundColor: palette.ink,
              fixedSize: const Size(43, 43),
            ),
          ),
          const SizedBox(width: 4),
          IconButton.filledTonal(
            tooltip: searchActive ? 'Close search' : 'Search tasks',
            onPressed: onSearch,
            icon: Icon(
              searchActive ? Icons.close_rounded : Icons.search_rounded,
            ),
            style: IconButton.styleFrom(
              backgroundColor: palette.surface,
              foregroundColor: palette.ink,
              fixedSize: const Size(43, 43),
            ),
          ),
        ],
      );
    },
  );
}
