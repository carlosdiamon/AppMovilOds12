import 'package:flutter/material.dart';
import '../../controllers/streak_controller.dart';

class StreakWidget extends StatelessWidget {
  final StreakController streakController;

  const StreakWidget({super.key, required this.streakController});

  @override
  Widget build(BuildContext context) {
    final streak = streakController.streak.value;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.local_fire_department, color: Colors.orange),
        SizedBox(width: 8),
        Text('Racha actual: $streak', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}