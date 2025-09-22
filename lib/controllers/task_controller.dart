import '../models/task.dart';
import '../services/db_service.dart';

class TaskController {
  final DbService dbService;

  TaskController(this.dbService);

  List<Task> getTasksForToday(DateTime today) {
    final allTasks = dbService.getAllTasks();
    return allTasks.where((task) {
      switch (task.repeatType) {
        case RepeatType.daily:
          return true;

        case RepeatType.weekly:
          return task.creationDate.weekday == today.weekday;

        case RepeatType.monthly:
          final creationDay = task.creationDate.day;
          final lastDayOfMonth = DateTime(today.year, today.month + 1, 0).day;
          final effectiveDay = creationDay <= lastDayOfMonth ? creationDay : lastDayOfMonth;
          return today.day == effectiveDay;

        case RepeatType.specific:
          return task.specificDate != null &&
              task.specificDate!.year == today.year &&
              task.specificDate!.month == today.month &&
              task.specificDate!.day == today.day;
      }
    }).toList();
  }

  Future<void> setTaskCompletion(Task task, bool isCompleted) async {
    task.isCompleted = isCompleted;
    await dbService.updateTask(task);
  }

  Future<void> addTask(Task task) async => dbService.addTask(task);

  Future<void> deleteTask(Task task) async => dbService.deleteTask(task);

  Future<void> editTask(Task task) async => dbService.updateTask(task);
}
