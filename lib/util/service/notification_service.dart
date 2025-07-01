import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notiProvider = Provider((ref) {
  final notification = NotificationService();
  return notification;
});

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isinitialized = false;

  bool get isInitialized => _isinitialized;

  // initialize
  Future<void> initNotification() async {
    if (_isinitialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    //prepare android init settings
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    // finally, initialize the plugin
    await notificationsPlugin.initialize(initSettings);
  }

  // NOTIFICATIONS DETAIL SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notification Channel',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // SHOW NOTIFICATION
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }

  // Scheduled Notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  // CANCEL NOTIFICATION
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
