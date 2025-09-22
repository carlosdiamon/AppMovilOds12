import 'package:flutter/material.dart';
import 'controllers/habit_controller.dart';
import 'views/habit_list_view.dart';

void main() {
  runApp(const EcoHabitsApp());
}

class EcoHabitsApp extends StatelessWidget {
  const EcoHabitsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HabitController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco Hábitos',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HabitListView(controller: controller),
    );
  }
}
