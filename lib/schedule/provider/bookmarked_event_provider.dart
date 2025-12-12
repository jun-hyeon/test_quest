import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/db/app_database.dart';
import 'package:test_quest/util/service/event_reminder_manager.dart';

final bookmarkedEventProvider =
    AsyncNotifierProvider<BookmarkedEventNotifier, List<CalendarEvent>>(
      BookmarkedEventNotifier.new,
    );

class BookmarkedEventNotifier extends AsyncNotifier<List<CalendarEvent>> {
  late final EventReminderManager eventManager;

  @override
  FutureOr<List<CalendarEvent>> build() async {
    eventManager = ref.read(eventReminderManager);
    final list = await eventManager.getAllEvents();
    return list;
  }

  Future<void> getEvent() async {
    await eventManager.getAllEvents();
    state = AsyncData(await eventManager.getAllEvents());
  }

  Future<void> addEvent(CalendarEventsCompanion event) async {
    await eventManager.addEvent(event);
    state = AsyncData(await eventManager.getAllEvents());
  }

  Future<void> deleteEvent(int id) async {
    await eventManager.deleteEvent(id);
    state = AsyncData(await eventManager.getAllEvents());
  }

  // postId로 이벤트를 찾아 삭제하는 메서드 추가
  Future<void> deleteEventByPostId(String postId) async {
    await eventManager.deleteEventByPostId(postId);
    state = AsyncData(await eventManager.getAllEvents()); // 상태 새로고침
  }

  // postId로 이벤트가 북마크되었는지 확인하는 메서드 추가
  Future<bool> checkIsBookmarked(String postId) async {
    return await eventManager.isBookmarked(postId);
  }

  Future<void> updateEvent(CalendarEvent event) async {
    await eventManager.updateEvent(event);

    //기존 알림 삭제 후 등록
    for (int i = 1; i <= 3; i++) {
      await eventManager.notificationService.cancelNotification(
        event.id * 10 + i,
      );
    }

    await addEvent(event.toCompanion(false));
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await eventManager.getAllEvents());
  }
}
