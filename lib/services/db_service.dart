import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/task.dart';
import '../models/streak.dart';

class DbService {
  Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox('tasks');
    await Hive.openBox('streaks');
    await Hive.openBox('config');
  }

  Box get taskBox => Hive.box('tasks');
  Box get streakBox => Hive.box('streaks');
  Box get configBox => Hive.box('config');

  Future<void> addTask(Task task) async {
    await taskBox.put(task.id.toString(), task.toMap());
  }

  List<Task> getAllTasks() {
    return taskBox.values
        .map((map) => Task.fromMap(Map<String, dynamic>.from(map)))
        .toList();
  }

  Future<void> deleteTask(Task task) async {
    await taskBox.delete(task.id.toString());
  }

  Future<void> updateTask(Task task) async {
    await taskBox.put(task.id.toString(), task.toMap());
  }

  Streak getStreak() {
    final map = streakBox.get('streak');
    if (map != null) {
      return Streak.fromMap(Map<String, dynamic>.from(map));
    }
    return Streak(value: 0, lastUpdated: DateTime.now());
  }

  Future<void> saveStreak(Streak streak) async {
    await streakBox.put('streak', streak.toMap());
  }

  String getThemeMode() => configBox.get('themeMode', defaultValue: 'system');
  Future<void> setThemeMode(String mode) async =>
      await configBox.put('themeMode', mode);
}