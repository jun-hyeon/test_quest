import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_quest/common/component/calendar_event_card.dart';
import 'package:test_quest/schedule/provider/bookmarked_event_provider.dart';
import 'package:test_quest/util/db/app_database.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final state = ref.watch(bookmarkedEventProvider);

    List<CalendarEvent> getEventsForDay(DateTime day) {
      return state.when(
          data: (data) {
            return data.where((event) {
              final start = DateTime(event.startDate.year,
                  event.startDate.month, event.startDate.day);
              final end = DateTime(
                  event.endDate.year, event.endDate.month, event.endDate.day);
              final target = DateTime(day.year, day.month, day.day);

              return target.isAtSameMomentAs(start) ||
                  target.isAtSameMomentAs(end) ||
                  (target.isAfter(start) && target.isBefore(end));
            }).toList();
          },
          error: (error, stack) => [],
          loading: () => []);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('일정 추가'),
        onPressed: () {
          final titleController = TextEditingController();
          DateTime? startDate;
          DateTime? endDate;

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 24,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration:
                              const InputDecoration(labelText: '이벤트 제목'),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => startDate = picked);
                                  }
                                },
                                child: Text(startDate == null
                                    ? '시작일 선택'
                                    : '시작일: ${startDate!.toLocal()}'
                                        .split(' ')[0]),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                  );
                                  if (picked != null) {
                                    setState(() => endDate = picked);
                                  }
                                },
                                child: Text(endDate == null
                                    ? '종료일 선택'
                                    : '종료일: ${endDate!.toLocal()}'
                                        .split(' ')[0]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (titleController.text.isNotEmpty &&
                                startDate != null &&
                                endDate != null) {
                              final newEvent = CalendarEventsCompanion(
                                title: Value(titleController.text),
                                startDate: Value(startDate!),
                                endDate: Value(endDate!),
                                description: const Value("test"),
                              );

                              Navigator.of(context).pop();

                              await ref
                                  .read(bookmarkedEventProvider.notifier)
                                  .addEvent(newEvent);
                            }
                          },
                          child: const Text('일정 등록'),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: const Text('테스트 일정'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('$error'),
          ),
          data: (data) => Column(
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
                child: state.when(
                  data: (data) {
                    final filteredEvents = _selectedDay != null
                        ? getEventsForDay(_selectedDay!)
                        : [];

                    if (filteredEvents.isEmpty) {
                      return const Center(child: Text('등록된 일정이 없습니다.'));
                    }

                    return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        return CalendarEventCard(event: filteredEvents[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('오류: $e')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
