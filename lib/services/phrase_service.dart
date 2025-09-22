import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/motivational_phrase.dart';

class PhraseService {
  List<MotivationalPhrase> _phrases = [];

  Future<void> loadPhrases() async {
    final String jsonString = await rootBundle.loadString('assets/resources/motivations.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    _phrases = jsonData
        .map((e) => e is String
        ? MotivationalPhrase(text: e)
        : MotivationalPhrase.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  MotivationalPhrase getRandomPhrase() {
    _phrases.shuffle();
    return _phrases.isNotEmpty
        ? _phrases.first
        : MotivationalPhrase(text: "¡Hazlo!");
  }
}