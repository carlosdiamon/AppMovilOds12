import 'package:flutter/material.dart';
import '../../controllers/streak_controller.dart';

class TreeWidget extends StatelessWidget {
  final StreakController streakController;

  const TreeWidget({super.key, required this.streakController});

  @override
  Widget build(BuildContext context) {
    final streak = streakController.streak.value;
    String asset;
    if (streak < 3) {
      asset = 'assets/images/tree_level_0.png';
    } else if (streak < 7) {
      asset = 'assets/images/tree_level_1.png';
    } else {
      asset = 'assets/images/tree_level_2.png';
    }

    return Image.asset(asset, height: 120);
  }
}
