import 'package:drift/drift.dart';

class CalendarEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get postId => text().nullable()();
  TextColumn get title => text().withLength(max: 32)();
  TextColumn get auth => text()();
  TextColumn get thumbnailUrl => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}
