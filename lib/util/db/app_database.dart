import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:test_quest/schedule/model/test_post_event.dart';

part 'app_database.g.dart';

final dbProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

@DriftDatabase(tables: [CalendarEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Create
  Future<int> insertEvent(CalendarEventsCompanion event) =>
      into(calendarEvents).insert(event);

  // Read
  Future<List<CalendarEvent>> getAllEvents() => select(calendarEvents).get();

  Stream<List<CalendarEvent>> watchAllEvents() =>
      select(calendarEvents).watch();

  // Read by postId
  Future<CalendarEvent?> getEventByPostId(String postId) {
    return (select(
      calendarEvents,
    )..where((tbl) => tbl.postId.equals(postId))).getSingleOrNull();
  }

  // Update
  Future<bool> updateEvent(CalendarEvent event) =>
      update(calendarEvents).replace(event);

  // Delete
  Future<int> deleteEvent(int id) =>
      (delete(calendarEvents)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}
