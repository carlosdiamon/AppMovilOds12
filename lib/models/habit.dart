class Habit {
  final String title;
  final DateTime time; // hora a la que se debe mostrar
  bool isCompleted;

  Habit({
    required this.title,
    required this.time,
    this.isCompleted = false,
  });
}
