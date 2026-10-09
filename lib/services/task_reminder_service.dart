import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../enums/task/task_reminder.dart';
import '../extensions/task_reminder_details.dart';
import '../interfaces/task_reminder_scheduler.dart';
import '../models/todo_task.dart';
import '../utils/task_notification_id.dart';

class TaskReminderService implements TaskReminderScheduler {
  TaskReminderService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _initialization;

  Future<void> _initialize() => _initialization ??= _setup();

  Future<void> _setup() async {
    tz_data.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  @override
  Future<bool> requestPermission() async {
    await _initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return false;
  }

  @override
  Future<void> sync(TodoTask task) async {
    await _initialize();
    final id = taskNotificationId(task.id);
    await _plugin.cancel(id: id);
    if (task.isCompleted ||
        task.reminder == TaskReminder.none ||
        task.dueAt == null) {
      return;
    }
    final scheduled = task.dueAt!.subtract(task.reminder.leadTime);
    if (!scheduled.isAfter(DateTime.now())) return;
    await _plugin.zonedSchedule(
      id: id,
      title: task.title,
      body: task.reminder == TaskReminder.atTime
          ? 'Your task is due now.'
          : 'Your task is due soon.',
      scheduledDate: tz.TZDateTime.from(scheduled, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_reminders',
          'Task reminders',
          channelDescription: 'Reminders for tasks with due dates',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(String taskId) async {
    await _initialize();
    await _plugin.cancel(id: taskNotificationId(taskId));
  }
}
