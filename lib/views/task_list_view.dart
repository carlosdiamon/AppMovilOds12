import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'widgets/task_card_widget.dart';

class TaskListView extends StatelessWidget {
  final TaskController controller;

  const TaskListView({super.key, required this.controller});

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
  );

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('tasks');

    return Scaffold(
      appBar: AppBar(title: const Text('Tus tareas')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box boxSnapshot, _) {
          final allTasks = boxSnapshot.values
              .map((m) => Task.fromMap(Map<String, dynamic>.from(m)))
              .toList();

          allTasks.sort((a, b) => b.creationDate.compareTo(a.creationDate));

          final today = DateTime.now();
          final todayTasksAll = controller.getTasksForToday(today);

          final todayIds = todayTasksAll.map((t) => t.id).toSet();

          final pendingToday = todayTasksAll.where((t) => !t.isCompleted).toList();
          final completed = allTasks.where((t) => t.isCompleted).toList();
          final others = allTasks.where((t) => !t.isCompleted && !todayIds.contains(t.id)).toList();

          final hasAny = pendingToday.isNotEmpty || completed.isNotEmpty || others.isNotEmpty;

          if (!hasAny) {
            return const Center(child: Text('No tienes tareas aún.'));
          }

          final children = <Widget>[];

          if (pendingToday.isNotEmpty) {
            children.add(_sectionHeader('Pendientes (hoy)'));
            children.addAll(pendingToday.map((t) => TaskCardWidget(task: t, controller: controller)));
          }

          if (completed.isNotEmpty) {
            children.add(_sectionHeader('Ya realizadas'));
            children.addAll(completed.map((t) => TaskCardWidget(task: t, controller: controller)));
          }

          if (others.isNotEmpty) {
            children.add(_sectionHeader('Otras'));
            children.addAll(others.map((t) => TaskCardWidget(task: t, controller: controller)));
          }

          children.add(const SizedBox(height: 80));

          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: children.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, index) => children[index],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/edit');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
