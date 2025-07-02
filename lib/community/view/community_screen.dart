import 'package:flutter/material.dart';
import 'package:test_quest/community/component/community_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조회'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [
          CommunityCard(
            thumbnailUrl: 'https://via.placeholder.com/80',
            title: '커뮤니티 게시글 1',
            author: '작성자 A',
            startDate: '2024-06-01',
            endDate: '2024-06-10',
            views: 123,
            status: '모집중',
          ),
          CommunityCard(
            thumbnailUrl: 'https://via.placeholder.com/80',
            title: '커뮤니티 게시글 2',
            author: '작성자 B',
            startDate: '2024-06-05',
            endDate: '2024-06-15',
            views: 456,
            status: '모집완료',
          ),
          CommunityCard(
            thumbnailUrl: 'https://via.placeholder.com/80',
            title: '커뮤니티 게시글 3',
            author: '작성자 C',
            startDate: '2024-06-10',
            endDate: '2024-06-20',
            views: 789,
            status: '모집중',
          ),
        ],
      ),
    );
  }
}
