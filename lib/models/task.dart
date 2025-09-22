enum RepeatType { daily, weekly, monthly, specific }

class Task {
  int id;
  String name;
  RepeatType repeatType;
  DateTime creationDate;
  DateTime? specificDate;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.repeatType,
    required this.creationDate,
    this.specificDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'repeatType': repeatType.index,
    'creationDate': creationDate.toIso8601String(),
    'specificDate': specificDate?.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory Task.fromMap(Map<dynamic, dynamic> map) => Task(
    id: map['id'],
    name: map['name'],
    repeatType: RepeatType.values[map['repeatType']],
    creationDate: DateTime.parse(map['creationDate']),
    specificDate: map['specificDate'] != null
        ? DateTime.parse(map['specificDate'])
        : null,
    isCompleted: map['isCompleted'] ?? false,
  );
}