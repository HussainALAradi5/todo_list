class TaskTimeFilter {
  const TaskTimeFilter({
    this.fromDay,
    this.toDay,
    this.fromMinute,
    this.toMinute,
  });

  final DateTime? fromDay;
  final DateTime? toDay;
  final int? fromMinute;
  final int? toMinute;
}
