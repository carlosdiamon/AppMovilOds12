class MotivationalPhrase {
  final String text;

  MotivationalPhrase({required this.text});

  factory MotivationalPhrase.fromJson(Map<String, dynamic> json) {
    return MotivationalPhrase(text: json['text'] as String);
  }
}