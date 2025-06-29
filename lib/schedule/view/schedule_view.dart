import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_quest/common/component/calendar_event_card.dart';

import '../model/calendar_event.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final List<CalendarEvent> events = [
      CalendarEvent(
        title: 'CBT 모집 마감',
        startDate: DateTime(2025, 7, 1),
        endDate: DateTime(2025, 7, 7),
      ),
      CalendarEvent(
        title: 'OBT 일정 공개',
        startDate: DateTime(2025, 7, 10),
        endDate: DateTime(2025, 7, 15),
      ),
    ];

    List<CalendarEvent> getEventsForDay(DateTime day) {
      return events.where((event) {
        return day.isAfter(event.startDate.subtract(const Duration(days: 1))) &&
            day.isBefore(event.endDate.add(const Duration(days: 1)));
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 일정'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: getEventsForDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: isDark ? Colors.orange[200] : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: isDark ? Colors.deepOrange : Colors.amber,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: isDark ? Colors.orangeAccent : primaryColor,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                weekendTextStyle: TextStyle(
                  color: isDark ? Colors.orange[100] : Colors.orange,
                ),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                outsideDaysVisible: false,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return CalendarEventCard(event: events[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
