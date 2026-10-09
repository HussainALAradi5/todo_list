import '../enums/task/task_category.dart';
import '../enums/task/task_priority.dart';
import '../models/todo_task.dart';

class StarterTaskService {
  const StarterTaskService();

  List<TodoTask> create(DateTime today) {
    DateTime at(int dayOffset, int hour, int minute) =>
        DateTime(today.year, today.month, today.day + dayOffset, hour, minute);
    return [
      TodoTask(
        id: 'starter-1',
        title: 'Plan the week ahead',
        notes: 'Pick the three things that matter most.',
        dueAt: at(0, 9, 0),
        category: TaskCategory.work,
        priority: TaskPriority.high,
      ),
      TodoTask(
        id: 'starter-2',
        title: 'Review project notes',
        dueAt: at(0, 11, 30),
        category: TaskCategory.work,
      ),
      TodoTask(
        id: 'starter-3',
        title: 'Go for an evening walk',
        dueAt: at(0, 18, 0),
        category: TaskCategory.wellness,
      ),
      TodoTask(
        id: 'starter-4',
        title: 'Read for 20 minutes',
        dueAt: at(1, 20, 0),
        category: TaskCategory.personal,
      ),
    ];
  }
}
