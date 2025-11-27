import 'package:flutter/material.dart';
import 'package:test_quest/community/view/community_screen.dart';
import 'package:test_quest/mypage/view/my_page_screen.dart';
import 'package:test_quest/schedule/view/schedule_view.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [
    const ScheduleScreen(),
    const CommunityScreen(),
    const MyPageScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event_outlined),
            selectedIcon: Icon(Icons.event),
            label: '일정',
          ),
          NavigationDestination(
            icon: Icon(Icons.forum_outlined),
            selectedIcon: Icon(Icons.forum),
            label: '커뮤니티',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
