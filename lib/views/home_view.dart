import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/task_controller.dart';
import '../controllers/streak_controller.dart';
import '../services/phrase_service.dart';
import 'widgets/tree_widget.dart';
import 'widgets/streak_widget.dart';
import 'widgets/phrase_widget.dart';
import 'widgets/task_card_widget.dart';

class HomeView extends StatelessWidget {
  final TaskController taskController;
  final StreakController streakController;
  final PhraseService phraseService;

  const HomeView({
    required this.taskController,
    required this.streakController,
    required this.phraseService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('REVIU')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StreakWidget(streakController: streakController),
            const SizedBox(height: 8),
            PhraseWidget(phraseService: phraseService),
            const SizedBox(height: 8),
            TreeWidget(streakController: streakController),
            const SizedBox(height: 12),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.secondary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('tasks').listenable(),
                  builder: (context, Box boxSnapshot, _) {
                    final todayTasks = taskController.getTasksForToday(DateTime.now());

                    if (todayTasks.isEmpty) {
                      return const Center(child: Text('No hay actividades pendientes para hoy.'));
                    }

                    return ListView.builder(
                      itemCount: todayTasks.length,
                      itemBuilder: (context, i) => TaskCardWidget(
                        task: todayTasks[i],
                        controller: taskController,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/tasks'),
              icon: const Icon(Icons.settings),
              label: const Text('Configurar tareas'),
            ),
          ],
        ),
      ),
    );
  }
}
