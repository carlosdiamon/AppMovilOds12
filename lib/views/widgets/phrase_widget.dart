import 'package:flutter/material.dart';
import '../../services/phrase_service.dart';

class PhraseWidget extends StatelessWidget {
  final PhraseService phraseService;

  const PhraseWidget({super.key, required this.phraseService});

  @override
  Widget build(BuildContext context) {
    final phrase = phraseService.getRandomPhrase();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        '"${phrase.text}"',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
      ),
    );
  }
}