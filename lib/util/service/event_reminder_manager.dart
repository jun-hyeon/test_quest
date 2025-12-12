import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/db/app_database.dart';
import 'package:test_quest/util/service/notification_service.dart';

final eventReminderManager = Provider<EventReminderManager>((ref) {
  final db = ref.read(dbProvider);
  final notiService = ref.read(notiProvider);
  return EventReminderManager(db: db, notificationService: notiService);
});

class EventReminderManager {
  final AppDatabase db;
  final NotificationService notificationService;

  EventReminderManager({required this.db, required this.notificationService});

  Future<void> addEvent(CalendarEventsCompanion newEvent) async {
    final id = await db.insertEvent(newEvent);

    final eventDate = newEvent.startDate.value;
    final dayBefore9AM = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day - 1,
      9,
    );

    final sixHourBefore = eventDate.subtract(const Duration(hours: 6));
    // final now = DateTime.now();
    // final testDate = now.add(const Duration(seconds: 5));

    await notificationService.showNotification(
      id: id * 10 + 1,
      title: "${newEvent.title.value}이 일정에 등록되었습니다!",
    );

    //알림 스케줄 설정
    await notificationService.scheduleNotification(
      id: id * 10 + 1,
      title: "📅${newEvent.title}",
      body: "하루 전 알림입니다.",
      dateTime: dayBefore9AM,
    );

    //알림 스케줄 설정
    await notificationService.scheduleNotification(
      id: id * 10 + 2,
      title: "📅${newEvent.title}",
      body: "6시간 전 알림입니다!",
      dateTime: sixHourBefore,
    );
  }

  Future<void> deleteEvent(int eventId) async {
    await db.deleteEvent(eventId);

    for (int i = 1; i <= 3; i++) {
      await notificationService.cancelNotification(eventId * 10 + i);
    }
  }

  Future<void> deleteEventByPostId(String postId) async {
    final event = await db.getEventByPostId(postId);
    if (event != null) {
      await db.deleteEvent(event.id);
      for (int i = 1; i <= 3; i++) {
        await notificationService.cancelNotification(event.id * 10 + i);
      }
    }
  }

  Future<List<CalendarEvent>> getAllEvents() async {
    return await db.getAllEvents();
  }

  Future<bool> isBookmarked(String postId) async {
    final event = await db.getEventByPostId(postId);
    return event != null;
  }

  Future<void> updateEvent(CalendarEvent updateEvent) async {
    await db.updateEvent(updateEvent);

    //기존 알림 삭제 후 등록
    for (int i = 1; i <= 3; i++) {
      await notificationService.cancelNotification(updateEvent.id * 10 + i);
    }

    await addEvent(updateEvent.toCompanion(false));
  }
}
