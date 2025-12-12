// 클래스 정의 (클래스 외부 또는 내부에 추가)
import 'package:flutter/material.dart';

class CalendarSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  CalendarSliverDelegate({
    required this.child,
    required this.maxHeight,
    required this.minHeight,
  });

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(CalendarSliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
