import 'package:flutter/material.dart';

import '../../models/task_time_filter.dart';
import '../../theme/app_palette.dart';
import '../../utils/date_format.dart';

class TaskTimeFilterBar extends StatelessWidget {
  const TaskTimeFilterBar({
    super.key,
    required this.filter,
    required this.onOpen,
    required this.onClear,
  });

  final TaskTimeFilter? filter;
  final VoidCallback onOpen;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.tune_rounded, size: 19),
              label: Text(
                filter != null
                    ? 'Filtered'
                    : constraints.maxWidth < 240
                    ? 'Filter'
                    : 'Date & time',
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: filter == null
                    ? context.palette.ink
                    : context.palette.primary,
                side: BorderSide(color: context.palette.border),
              ),
            ),
            if (filter != null) ...[
              const SizedBox(width: 6),
              IconButton(
                tooltip: 'Clear date and time filter',
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded, size: 19),
              ),
            ],
          ],
        ),
        if (filter != null)
          Text(
            _summary(context, filter!),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.palette.muted, fontSize: 12),
          ),
      ],
    ),
  );

  String _summary(BuildContext context, TaskTimeFilter value) {
    final days = switch ((value.fromDay, value.toDay)) {
      (final DateTime from, final DateTime to) when from == to => longDate(
        from,
      ),
      (final DateTime from, final DateTime to) =>
        '${longDate(from)} – ${longDate(to)}',
      (final DateTime from, null) => 'From ${longDate(from)}',
      (null, final DateTime to) => 'Through ${longDate(to)}',
      _ => null,
    };
    String time(int minute) =>
        TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context);
    final hours = switch ((value.fromMinute, value.toMinute)) {
      (final int from, final int to) => '${time(from)} – ${time(to)}',
      (final int from, null) => 'From ${time(from)}',
      (null, final int to) => 'Until ${time(to)}',
      _ => null,
    };
    return [?days, ?hours].join(' · ');
  }
}
