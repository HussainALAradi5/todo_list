import 'package:flutter/material.dart';

import '../../models/task_time_filter.dart';
import 'task_time_filter_form.dart';

class TaskTimeFilterSheet extends StatefulWidget {
  const TaskTimeFilterSheet({super.key, this.initial});

  final TaskTimeFilter? initial;

  @override
  State<TaskTimeFilterSheet> createState() => _TaskTimeFilterSheetState();
}

class _TaskTimeFilterSheetState extends State<TaskTimeFilterSheet> {
  DateTime? _fromDay;
  DateTime? _toDay;
  int? _fromMinute;
  int? _toMinute;

  @override
  void initState() {
    super.initState();
    _fromDay = widget.initial?.fromDay;
    _toDay = widget.initial?.toDay;
    _fromMinute = widget.initial?.fromMinute;
    _toMinute = widget.initial?.toMinute;
  }

  Future<void> _pickDay(bool start) async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: (start ? _fromDay : _toDay) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (chosen == null || !mounted) return;
    setState(() {
      if (start) {
        _fromDay = chosen;
      } else {
        _toDay = chosen;
      }
    });
  }

  Future<void> _pickTime(bool start) async {
    final minute = start ? _fromMinute : _toMinute;
    final chosen = await showTimePicker(
      context: context,
      initialTime: minute == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: minute ~/ 60, minute: minute % 60),
    );
    if (chosen == null || !mounted) return;
    setState(() {
      if (start) {
        _fromMinute = chosen.hour * 60 + chosen.minute;
      } else {
        _toMinute = chosen.hour * 60 + chosen.minute;
      }
    });
  }

  void _quickDay(int offset) {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day + offset);
    setState(() {
      _fromDay = day;
      _toDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    final invalidDays =
        _fromDay != null && _toDay != null && _fromDay!.isAfter(_toDay!);
    final media = MediaQuery.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: Align(
          alignment: Alignment.bottomCenter,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 560,
              maxHeight: media.size.height * .88,
            ),
            child: TaskTimeFilterForm(
              fromDay: _fromDay,
              toDay: _toDay,
              fromMinute: _fromMinute,
              toMinute: _toMinute,
              invalidDays: invalidDays,
              onQuickDay: _quickDay,
              onPickDay: _pickDay,
              onPickTime: _pickTime,
              onClear: () => Navigator.pop(context, const TaskTimeFilter()),
              onApply: () => Navigator.pop(
                context,
                TaskTimeFilter(
                  fromDay: _fromDay,
                  toDay: _toDay,
                  fromMinute: _fromMinute,
                  toMinute: _toMinute,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
