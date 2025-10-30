import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_quest/common/component/calendar_event_card.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/schedule/provider/bookmarked_event_provider.dart';
import 'package:test_quest/schedule/view/sliver_persistent_header_delegate.dart';
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
  final ScrollController _scrollController = ScrollController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  double _calendarHeightFactor = 0.45;

  final List<double> _heights = [0.25, 0.35, 0.45];
  final List<CalendarFormat> _formats = [
    CalendarFormat.week,
    CalendarFormat.twoWeeks,
    CalendarFormat.month,
  ];

  int _stageIndex = 2; // 0: week, 1: twoWeeks, 2: month
  double _accum = 0; // 누적 스크롤
  final double _threshold = 250; // 단계 전환 임계치(px)
  double _lastOffset = 0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
    _calendarHeightFactor = _heights[_stageIndex];
    _calendarFormat = _formats[_stageIndex];
  }

  void scrollListener() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;
    final delta = offset - _lastOffset; // +아래, -위
    _lastOffset = offset;

    if (delta == 0) return;

    // 누적: 아래로 스크롤 → 음수(축소), 위로 스크롤 → 양수(확대)
    _accum += -delta;

    // 확대(위로) 트리거
    if (_accum >= _threshold && _stageIndex < _heights.length - 1) {
      _stageIndex++;
      _accum = 0;
      setState(() {
        _calendarHeightFactor = _heights[_stageIndex];
        _calendarFormat = _formats[_stageIndex];
      });
      return;
    }

    // 축소(아래로) 트리거
    if (_accum <= -_threshold && _stageIndex > 0) {
      _stageIndex--;
      _accum = 0;
      setState(() {
        _calendarHeightFactor = _heights[_stageIndex];
        _calendarFormat = _formats[_stageIndex];
      });
    }
  }

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
    // 화면 높이 구하기
    final screenHeight = MediaQuery.of(context).size.height;
    // 현재 높이 비율에 따른 실제 캘린더 높이 계산
    final calendarHeight = screenHeight * _calendarHeightFactor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final state = ref.watch(bookmarkedEventProvider);
    final user = ref.watch(currentUserProvider);
    final auth = user?.nickname ?? '';

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

    final filteredEvents =
        _selectedDay != null ? getEventsForDay(_selectedDay!) : [];

    return Scaffold(
      floatingActionButton:
          _buildFloatingActionButton(context: context, auth: auth, ref: ref),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('$error'),
        ),
        data: (data) => _buildScrollableBody(
          calendarHeight: calendarHeight,
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
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      label: const Text('일정 추가'),
      onPressed: () => _showAddEventSheet(context, auth, ref),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
                              : '시작일: ${startDate!.toString().split(' ')[0]}'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
                              : '종료일: ${endDate!.toString().split(' ')[0]}'),
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
    required double calendarHeight,
    required bool isDark,
    required Color primaryColor,
    required List<CalendarEvent> Function(DateTime) getEventsForDay,
    required List<CalendarEvent> filteredEvents,
    required AsyncValue<List<CalendarEvent>> state,
  }) {
    return NotificationListener<UserScrollNotification>(
      onNotification: (n) {
        if (n.direction == ScrollDirection.idle) return false;
        if (n.direction == ScrollDirection.forward) {
          _accum += 30;
          if (_accum >= _threshold && _stageIndex < _heights.length - 1) {
            _stageIndex++;
            _accum = 0;
            setState(() {
              _calendarHeightFactor = _heights[_stageIndex];
              _calendarFormat = _formats[_stageIndex];
            });
          }
        }
        if (n.direction == ScrollDirection.reverse) {
          _accum -= 30;
          if (_accum <= -_threshold && _stageIndex > 0) {
            _stageIndex--;
            _accum = 0;
            setState(() {
              _calendarHeightFactor = _heights[_stageIndex];
              _calendarFormat = _formats[_stageIndex];
            });
          }
        }
        return false;
      },
      child: CustomScrollView(
        controller: _scrollController,
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
            calendarHeight: calendarHeight,
            isDark: isDark,
            primaryColor: primaryColor,
            getEventsForDay: getEventsForDay,
          ),
          _buildEventListSliver(filteredEvents: filteredEvents, state: state),
        ],
      ),
    );
  }

  SliverPersistentHeader _buildCalendarSliver({
    required double calendarHeight,
    required bool isDark,
    required Color primaryColor,
    required List<CalendarEvent> Function(DateTime) getEventsForDay,
  }) {
    return SliverPersistentHeader(
      floating: true,
      delegate: CalendarSliverDelegate(
        maxHeight: calendarHeight,
        minHeight: 150,
        child: AnimatedContainer(
          height: calendarHeight,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Column(
            children: [
              Expanded(
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
              ),
            ],
          ),
        ),
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
                context.push('/post_detail',
                    extra: filteredEvents[index].postId);
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
