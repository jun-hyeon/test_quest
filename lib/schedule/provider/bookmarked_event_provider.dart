import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/db/app_database.dart';
import 'package:test_quest/util/service/event_reminder_manager.dart';

final bookmarkedEventProvider =
    AsyncNotifierProvider<BookmarkedEventNotifier, List<CalendarEvent>>(
        BookmarkedEventNotifier.new);

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

  Future<void> updateEvent(CalendarEvent event) async {
    await eventManager.updateEvent(event);
    state = AsyncData(await eventManager.getAllEvents());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await eventManager.getAllEvents());
  }
}
