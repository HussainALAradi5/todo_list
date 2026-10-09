import '../enums/task/task_reminder.dart';

extension TaskReminderDetails on TaskReminder {
  String get label => switch (this) {
    TaskReminder.none => 'Off',
    TaskReminder.atTime => 'At due time',
    TaskReminder.tenMinutesBefore => '10 min before',
    TaskReminder.oneHourBefore => '1 hour before',
    TaskReminder.oneDayBefore => '1 day before',
  };

  Duration get leadTime => switch (this) {
    TaskReminder.none || TaskReminder.atTime => Duration.zero,
    TaskReminder.tenMinutesBefore => const Duration(minutes: 10),
    TaskReminder.oneHourBefore => const Duration(hours: 1),
    TaskReminder.oneDayBefore => const Duration(days: 1),
  };
}
