import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
  }

  Future<void> scheduleHabitReminder(String title, DateTime time) async {
    await _plugin.zonedSchedule(
      0,
      'Recordatorio de hábito',
      title,
      tz.TZDateTime.from(time, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('habit_channel', 'Hábitos'),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> sendStreakResetNotification() async {
    await _plugin.show(
      1,
      '¡Tu racha ha vencido!',
      'Recuerda completar tus hábitos para mejorar tu racha.',
      const NotificationDetails(
        android: AndroidNotificationDetails('streak_channel', 'Rachas'),
      ),
    );
  }
}