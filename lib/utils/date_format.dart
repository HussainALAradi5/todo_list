import 'package:flutter/material.dart';

String dateLabel(DateTime? value, DateTime now) {
  if (value == null) return 'Anytime';
  final date = DateUtils.dateOnly(value);
  final today = DateUtils.dateOnly(now);
  if (date == today) return 'Today';
  if (date == today.add(const Duration(days: 1))) return 'Tomorrow';
  if (date.isBefore(today)) return 'Overdue';
  return '${_weekdays[value.weekday - 1]}, ${value.day} ${_months[value.month - 1]}';
}

String timeLabel(DateTime? value, BuildContext context) {
  if (value == null) return '';
  return TimeOfDay.fromDateTime(value).format(context);
}

String longDate(DateTime value) =>
    '${_weekdays[value.weekday - 1]}, ${_months[value.month - 1]} ${value.day}';

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
