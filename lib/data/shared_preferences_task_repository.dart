import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import '../interfaces/task_repository.dart';
import '../mappers/todo_task_mapper.dart';
import '../models/todo_task.dart';

class SharedPreferencesTaskRepository implements TaskRepository {
  @override
  Future<List<TodoTask>?> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(StorageKeys.tasks);
    if (raw == null) return null;
    final items = jsonDecode(raw) as List<dynamic>;
    return items
        .map((item) => TodoTaskMapper.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(List<TodoTask> tasks) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      StorageKeys.tasks,
      jsonEncode(tasks.map(TodoTaskMapper.toJson).toList()),
    );
  }
}
