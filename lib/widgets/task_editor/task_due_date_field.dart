import 'package:flutter/material.dart';

import '../../theme/app_palette.dart';
import '../../utils/date_format.dart';
import 'field_label.dart';

class TaskDueDateField extends StatelessWidget {
  const TaskDueDateField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (date == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: value == null
          ? const TimeOfDay(hour: 9, minute: 0)
          : TimeOfDay.fromDateTime(value!),
    );
    if (!context.mounted) return;
    onChanged(
      DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('DUE DATE & TIME'),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _pickDate(context),
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: Text(
                value == null
                    ? 'Choose date & time'
                    : '${longDate(value!)} · ${timeLabel(value, context)}',
              ),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                foregroundColor: context.palette.ink,
                backgroundColor: context.palette.surface,
                minimumSize: const Size.fromHeight(56),
                side: BorderSide(color: context.palette.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
          if (value != null)
            IconButton(
              tooltip: 'Remove due date',
              onPressed: () => onChanged(null),
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    ],
  );
}
