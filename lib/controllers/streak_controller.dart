import '../models/streak.dart';
import '../services/db_service.dart';
import 'task_controller.dart';

class StreakController {
  final DbService dbService;
  final TaskController taskController;

  StreakController(this.dbService, this.taskController);

  Streak get streak => dbService.getStreak();

  Future<void> updateStreak(DateTime today) async {
    final streak = dbService.getStreak();
    final todayTasks = taskController.getTasksForToday(today);

    if (todayTasks.isEmpty) return;

    final completed = todayTasks.every((task) => task.isCompleted);
    final noneCompleted = todayTasks.every((task) => !task.isCompleted);

    if (noneCompleted) {
      streak.value = 0;
    } else if (completed) {
      streak.value++;
    } else {
      streak.value--;
      if (streak.value < 0) streak.value = 0;
    }
    streak.lastUpdated = today;
    await dbService.saveStreak(streak);
  }
}