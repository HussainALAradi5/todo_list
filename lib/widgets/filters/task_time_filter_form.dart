import 'package:flutter/material.dart';

import '../../enums/navigation/task_view.dart';
import '../../theme/app_palette.dart';
import '../../utils/date_format.dart';
import 'filter_range_field.dart';

class TaskTimeFilterForm extends StatelessWidget {
  const TaskTimeFilterForm({
    super.key,
    required this.view,
    required this.fromDay,
    required this.toDay,
    required this.fromMinute,
    required this.toMinute,
    required this.invalidDays,
    required this.onPickDay,
    required this.onPickTime,
    required this.onClear,
    required this.onApply,
  });

  final TaskView view;
  final DateTime? fromDay;
  final DateTime? toDay;
  final int? fromMinute;
  final int? toMinute;
  final bool invalidDays;
  final ValueChanged<bool> onPickDay;
  final ValueChanged<bool> onPickTime;
  final VoidCallback onClear;
  final VoidCallback onApply;

  String _timeText(BuildContext context, int? minute) => minute == null
      ? 'Any time'
      : TimeOfDay(hour: minute ~/ 60, minute: minute % 60).format(context);

  Widget _pair(Widget first, Widget second) => Row(
    children: [
      Expanded(child: first),
      const SizedBox(width: 10),
      Expanded(child: second),
    ],
  );

  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    shrinkWrap: true,
    padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
    children: [
      Text(
        view == TaskView.tasks ? 'Filter tasks' : 'Filter done tasks',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 5),
      Text(
        'Narrow this list by due date, time, or both.',
        style: TextStyle(color: context.palette.muted),
      ),
      const SizedBox(height: 20),
      _heading('DAY RANGE'),
      _pair(
        FilterRangeField(
          caption: 'From day',
          value: fromDay == null ? 'Any day' : longDate(fromDay!),
          icon: Icons.calendar_today_outlined,
          onPressed: () => onPickDay(true),
        ),
        FilterRangeField(
          caption: 'To day',
          value: toDay == null ? 'Any day' : longDate(toDay!),
          icon: Icons.event_rounded,
          onPressed: () => onPickDay(false),
        ),
      ),
      if (invalidDays)
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'End day must be on or after start day.',
            style: TextStyle(color: Colors.red),
          ),
        ),
      const SizedBox(height: 19),
      _heading('TIME RANGE'),
      _pair(
        FilterRangeField(
          caption: 'From time',
          value: _timeText(context, fromMinute),
          icon: Icons.schedule_rounded,
          onPressed: () => onPickTime(true),
        ),
        FilterRangeField(
          caption: 'To time',
          value: _timeText(context, toMinute),
          icon: Icons.schedule_rounded,
          onPressed: () => onPickTime(false),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        'A time range can cross midnight.',
        style: TextStyle(color: context.palette.muted, fontSize: 12),
      ),
      const SizedBox(height: 22),
      Row(
        children: [
          TextButton(onPressed: onClear, child: const Text('Clear')),
          const Spacer(),
          FilledButton(
            onPressed: invalidDays ? null : onApply,
            child: Text(view == TaskView.tasks ? 'Show tasks' : 'Show done'),
          ),
        ],
      ),
    ],
  );
}
