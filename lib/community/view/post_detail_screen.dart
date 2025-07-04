import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_quest/community/model/test_post.dart';

class PostDetailScreen extends StatelessWidget {
  final TestPost post;

  const PostDetailScreen({super.key, required this.post});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일').format(date);
  }

  String _platformLabel(TestPlatform platform) {
    switch (platform) {
      case TestPlatform.pc:
        return 'PC';
      case TestPlatform.mobile:
        return '모바일';
      case TestPlatform.console:
        return '콘솔';
    }
  }

  String _typeLabel(TestType type) {
    switch (type) {
      case TestType.alpha:
        return '알파테스트';
      case TestType.beta:
        return '베타테스트';
      case TestType.cbt:
        return 'CBT';
      case TestType.obt:
        return 'OBT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (post.boardImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.boardImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Placeholder(
                      strokeWidth: 1,
                      fallbackHeight: 200,
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              post.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(_platformLabel(post.platform)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_typeLabel(post.type)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '테스트 기간',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${_formatDate(post.startDate)} ~ ${_formatDate(post.endDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '작성일: ${_formatDate(post.createdAt)}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 32),
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (post.linkUrl != null)
              FilledButton(
                onPressed: () {
                  // 링크 열기 등 구현 필요
                },
                child: const Text('관련 링크 열기'),
              ),
          ],
        ),
      ),
    );
  }
}
