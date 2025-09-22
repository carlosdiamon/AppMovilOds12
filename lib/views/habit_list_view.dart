import 'package:flutter/material.dart';
import '../controllers/habit_controller.dart';
import '../models/habit.dart';

class HabitListView extends StatefulWidget {
  final HabitController controller;
  const HabitListView({Key? key, required this.controller}) : super(key: key);

  @override
  State<HabitListView> createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eco-Hábitos Diarios"),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: controller.progress,
            minHeight: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Progreso: ${(controller.progress * 100).toStringAsFixed(0)}% - "
                  "Puntos: ${controller.points}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.habits.length,
              itemBuilder: (context, index) {
                final habit = controller.habits[index];
                return CheckboxListTile(
                  title: Text(habit.title),
                  value: habit.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      controller.toggleHabit(habit);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
