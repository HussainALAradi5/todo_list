import 'package:flutter/material.dart';

import '../../enums/task/task_reminder.dart';
import '../../extensions/task_reminder_details.dart';
import '../../theme/app_palette.dart';
import 'field_label.dart';

class TaskReminderField extends StatelessWidget {
  const TaskReminderField({
    super.key,
    required this.dueAt,
    required this.value,
    required this.onChanged,
  });

  final DateTime? dueAt;
  final TaskReminder value;
  final ValueChanged<TaskReminder> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FieldLabel('REMINDER'),
      const SizedBox(height: 9),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final reminder in TaskReminder.values)
            ChoiceChip(
              label: Text(reminder.label),
              avatar: reminder == TaskReminder.none
                  ? null
                  : const Icon(Icons.notifications_none_rounded, size: 17),
              selected: value == reminder,
              onSelected:
                  reminder == TaskReminder.none ||
                      (dueAt != null &&
                          dueAt!
                              .subtract(reminder.leadTime)
                              .isAfter(DateTime.now()))
                  ? (_) => onChanged(reminder)
                  : null,
              showCheckmark: false,
              selectedColor: context.palette.primarySoft,
              side: BorderSide(
                color: value == reminder
                    ? context.palette.primary
                    : context.palette.border,
              ),
            ),
        ],
      ),
      const SizedBox(height: 6),
      Text(
        dueAt == null
            ? 'Choose a due date and time to enable a reminder.'
            : 'A local notification will arrive on this device.',
        style: TextStyle(color: context.palette.muted, fontSize: 12),
      ),
    ],
  );
}
