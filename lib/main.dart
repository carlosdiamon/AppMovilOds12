import 'package:flutter/material.dart';
import 'services/db_service.dart';
import 'controllers/task_controller.dart';
import 'controllers/streak_controller.dart';
import 'controllers/theme_controller.dart';
import 'services/phrase_service.dart';
import 'services/notification_service.dart';
import 'views/home_view.dart';
import 'views/task_list_view.dart';
import 'views/task_edit_view.dart';
import 'models/task.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = DbService();
  await dbService.initHive();

  final taskController = TaskController(dbService);
  final streakController = StreakController(dbService, taskController);
  final themeController = ThemeController(dbService);
  themeController.loadTheme();
  final phraseService = PhraseService();
  await phraseService.loadPhrases();
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(
    MaterialApp(
      title: 'REVIU',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeController.mode,
      initialRoute: '/',
      routes: {
        '/': (_) => HomeView(
          taskController: taskController,
          streakController: streakController,
          phraseService: phraseService,
        ),
        '/tasks': (_) => TaskListView(controller: taskController),
        '/edit': (context) {
          final task = ModalRoute.of(context)?.settings.arguments;
          return TaskEditView(task: task is Task ? task : null, controller: taskController);
        },
      },
    ),
  );
}