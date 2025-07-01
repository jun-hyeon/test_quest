// lib/schedule/component/event_card.dart

import 'package:flutter/material.dart';
import 'package:test_quest/util/db/app_database.dart';

class CalendarEventCard extends StatelessWidget {
  final CalendarEvent event;
  final VoidCallback? onTap;

  const CalendarEventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.brown[50];
    final borderColor = isDark ? Colors.deepOrange : Colors.brown;

    return InkWell(
      onTap: onTap,
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor, width: 1.2),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag, color: borderColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '시작일: ${_formatDate(event.startDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '종료일: ${_formatDate(event.endDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right, color: borderColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
