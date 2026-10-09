import '../models/task_time_filter.dart';

class TaskTimeFilterService {
  const TaskTimeFilterService();

  bool matches(DateTime? dueAt, TaskTimeFilter? filter) {
    if (filter == null) return true;
    if (dueAt == null) return false;
    final day = DateTime(dueAt.year, dueAt.month, dueAt.day);
    if (filter.fromDay != null && day.isBefore(filter.fromDay!)) return false;
    if (filter.toDay != null && day.isAfter(filter.toDay!)) return false;
    final minute = dueAt.hour * 60 + dueAt.minute;
    final from = filter.fromMinute;
    final to = filter.toMinute;
    if (from != null && to != null && from > to) {
      return minute >= from || minute <= to;
    }
    if (from != null && minute < from) return false;
    if (to != null && minute > to) return false;
    return true;
  }
}
