import '../models/habit.dart';

class HabitController {
  List<Habit> habits = [
    Habit(title: "¿Hoy separaste la basura?", time: DateTime.now().add(Duration(seconds: 5))),
    Habit(title: "¿Hoy evitaste plásticos de un solo uso?", time: DateTime.now().add(Duration(seconds: 10))),
    Habit(title: "¿Hoy apagaste luces innecesarias?", time: DateTime.now().add(Duration(seconds: 15))),
  ];

  int get completedCount => habits.where((h) => h.isCompleted).length;
  int get totalCount => habits.length;

  double get progress =>
      totalCount == 0 ? 0 : completedCount / totalCount;

  void toggleHabit(Habit habit) {
    habit.isCompleted = !habit.isCompleted;
  }

  int get points => completedCount * 10; // cada hábito = 10 puntos
}
