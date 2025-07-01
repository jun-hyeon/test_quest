import 'package:drift/drift.dart';

class CalendarEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(max: 32)();
  TextColumn get body => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
}

