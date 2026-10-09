import '../models/task_progress.dart';

extension TaskProgressValues on TaskProgress {
  int get remaining => total - completed;

  double get fraction => total == 0 ? 0 : completed / total;
}
