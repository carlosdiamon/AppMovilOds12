class Streak {
  int value;
  DateTime lastUpdated;

  Streak({required this.value, required this.lastUpdated});

  Map<String, dynamic> toMap() => {
    'value': value,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Streak.fromMap(Map<dynamic, dynamic> map) => Streak(
    value: map['value'],
    lastUpdated: DateTime.parse(map['lastUpdated']),
  );
}