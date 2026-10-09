import 'dart:async';

import 'package:flutter/foundation.dart';

import '../enums/navigation/task_view.dart';
import '../enums/task/task_category.dart';
import '../models/task_time_filter.dart';

class HomeFilterController extends ChangeNotifier {
  Timer? _searchTimer;
  static const searchDelay = Duration(milliseconds: 160);

  TaskView view = TaskView.today;
  TaskCategory? category;
  TaskTimeFilter? timeFilter;
  bool searchVisible = false;
  String query = '';

  void selectView(TaskView value) {
    _searchTimer?.cancel();
    view = value;
    category = null;
    query = '';
    searchVisible = false;
    notifyListeners();
  }

  void toggleSearch() {
    _searchTimer?.cancel();
    searchVisible = !searchVisible;
    if (!searchVisible) query = '';
    notifyListeners();
  }

  void setQuery(String value) {
    _searchTimer?.cancel();
    if (value.isEmpty) {
      query = '';
      notifyListeners();
      return;
    }
    _searchTimer = Timer(searchDelay, () {
      query = value;
      notifyListeners();
    });
  }

  void setCategory(TaskCategory? value) {
    category = value;
    notifyListeners();
  }

  void applyTimeFilter(TaskTimeFilter value) {
    final active =
        value.fromDay != null ||
        value.toDay != null ||
        value.fromMinute != null ||
        value.toMinute != null;
    timeFilter = active ? value : null;
    if (active && view != TaskView.completed) view = TaskView.all;
    notifyListeners();
  }

  void clearTimeFilter() {
    timeFilter = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}
