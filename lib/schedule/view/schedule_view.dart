import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_quest/common/component/calendar_event_card.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/schedule/provider/bookmarked_event_provider.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/util/db/app_database.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  void onDelete(int id) {
    ref.read(bookmarkedEventProvider.notifier).deleteEvent(id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookmarkedEventProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final state = ref.watch(bookmarkedEventProvider);
    final user = ref.watch(currentUserProvider);
    final auth = user?.nickname ?? '';

    List<CalendarEvent> getEventsForDay(DateTime day) {
      return state.when(
        data: (data) {
          return data.where((event) {
            final start = DateTime(
              event.startDate.year,
              event.startDate.month,
              event.startDate.day,
            );
            final end = DateTime(
              event.endDate.year,
              event.endDate.month,
              event.endDate.day,
            );
            final target = DateTime(day.year, day.month, day.day);

            return target.isAtSameMomentAs(start) ||
                target.isAtSameMomentAs(end) ||
                (target.isAfter(start) && target.isBefore(end));
          }).toList();
        },
        error: (error, stack) => [],
        loading: () => [],
      );
    }

    final filteredEvents = _selectedDay != null
        ? getEventsForDay(_selectedDay!)
        : [];

    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(
        context: context,
        auth: auth,
        ref: ref,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('$error')),
        data: (data) => _buildScrollableBody(
          isDark: isDark,
          primaryColor: primaryColor,
          getEventsForDay: getEventsForDay,
          filteredEvents: filteredEvents as List<CalendarEvent>,
          state: state,
        ),
      ),
    );
  }

  // ---------- Layout helpers ----------
  Widget _buildFloatingActionButton({
    required BuildContext context,
    required String auth,
    required WidgetRef ref,
  }) {
    return Semantics(
      label: '일정 추가',
      hint: '새로운 테스트 일정을 등록합니다',
      button: true,
      child: FloatingActionButton.extended(
        onPressed: () => _showAddEventSheet(context, auth, ref),
        icon: const Icon(Icons.add_outlined),
        label: const Text('일정 추가'),
      ),
    );
  }

  void _showAddEventSheet(BuildContext context, String auth, WidgetRef ref) {
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
                    decoration: const InputDecoration(labelText: '이벤트 제목'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
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
                          child: Text(
                            startDate == null
                                ? '시작일 선택'
                                : '시작일: ${startDate!.toString().split(' ')[0]}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
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
                          child: Text(
                            endDate == null
                                ? '종료일 선택'
                                : '종료일: ${endDate!.toString().split(' ')[0]}',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () async {
                      if (titleController.text.isNotEmpty &&
                          startDate != null &&
                          endDate != null) {
                        final newEvent = CalendarEventsCompanion(
                          postId: const Value(null),
                          auth: Value(auth),
                          title: Value(titleController.text),
                          startDate: Value(startDate!),
                          endDate: Value(endDate!),
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
  }

  Widget _buildScrollableBody({
    required bool isDark,
    required Color primaryColor,
    required List<CalendarEvent> Function(DateTime) getEventsForDay,
    required List<CalendarEvent> filteredEvents,
    required AsyncValue<List<CalendarEvent>> state,
  }) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const SliverAppBar(
          title: Text('일정'),
          centerTitle: true,
          pinned: false,
          floating: true,
          snap: false,
        ),
        _buildCalendarSliver(
          isDark: isDark,
          primaryColor: primaryColor,
          getEventsForDay: getEventsForDay,
        ),
        _buildEventListSliver(filteredEvents: filteredEvents, state: state),
      ],
    );
  }

  Widget _buildCalendarSliver({
    required bool isDark,
    required Color primaryColor,
    required List<CalendarEvent> Function(DateTime) getEventsForDay,
  }) {
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) {
          final colorScheme = Theme.of(context).colorScheme;

          return Container(
            padding: const EdgeInsets.all(8),
            child: TableCalendar(
              rowHeight: 52,
              calendarFormat: _calendarFormat,
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
                headerMargin: EdgeInsets.zero,
                headerPadding: EdgeInsets.all(4),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                defaultTextStyle: TextStyle(color: colorScheme.onSurface),
                weekendTextStyle: TextStyle(color: colorScheme.error),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
                outsideDaysVisible: false,
              ),
            ),
          );
        },
      ),
    );
  }

  SliverList _buildEventListSliver({
    required List<CalendarEvent> filteredEvents,
    required AsyncValue<List<CalendarEvent>> state,
  }) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return state.when(
          data: (data) {
            if (filteredEvents.isEmpty) {
              return const Center(child: Text('등록된 일정이 없습니다.'));
            }
            return CalendarEventCard(
              event: filteredEvents[index],
              onTap: () {
                context.push(
                  '/post_detail',
                  extra: filteredEvents[index].postId,
                );
              },
              onDelete: () {
                onDelete(filteredEvents[index].id);
              },
            );
          },
          error: (e, _) => Center(child: Text('오류: $e')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      }, childCount: filteredEvents.isEmpty ? 1 : filteredEvents.length),
    );
  }
}
