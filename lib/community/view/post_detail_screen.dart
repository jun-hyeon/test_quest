import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/post_provider.dart';
import 'package:test_quest/user/provider/user_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final TestPost post;

  const PostDetailScreen({super.key, required this.post});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  late TestPost _currentPost;

  @override
  void initState() {
    super.initState();
    _currentPost = widget.post;

    ref.listenManual(postProvider, (previous, next) {
      if (next is PostSuccess) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '글이 성공적으로 삭제되었습니다.',
            isError: false,
          );
          context.pop();
        }
      } else if (next is PostError) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '삭제에 실패했습니다. 다시 시도해주세요.',
            isError: true,
          );
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy년 MM월 dd일').format(date);
  }

  String _platformLabel(TestPlatform platform) {
    return switch (platform) {
      TestPlatform.pc => 'PC',
      TestPlatform.mobile => '모바일',
      TestPlatform.console => '콘솔',
      TestPlatform.unknown => 'unknown',
    };
  }

  String _typeLabel(TestType type) {
    return switch (type) {
      TestType.alpha => '알파테스트',
      TestType.beta => '베타테스트',
      TestType.cbt => 'CBT',
      TestType.obt => 'OBT',
      TestType.unknown => 'unknown',
    };
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isAuthor = currentUser?.nickname == _currentPost.author;
    final deleteState = ref.watch(postProvider);
    final isDeleting = deleteState is PostLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPost.title,
            style: Theme.of(context).textTheme.titleLarge),
        actions: [
          if (isAuthor)
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(context, ref, value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('수정'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  enabled: !isDeleting, // 삭제 중에는 비활성화
                  child: Row(
                    children: [
                      if (isDeleting)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        isDeleting ? '삭제 중...' : '삭제',
                        style: TextStyle(
                          color: isDeleting ? Colors.grey : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_currentPost.thumbnailUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _currentPost.thumbnailUrl!,
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
              _currentPost.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(
                  label: Text(_platformLabel(_currentPost.platform)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_typeLabel(_currentPost.type)),
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
              '${_formatDate(_currentPost.startDate)} ~ ${_formatDate(_currentPost.endDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              '작성일: ${_formatDate(_currentPost.createdAt)}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Divider(height: 32),
            Text(
              _currentPost.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
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

  /// 메뉴 액션 처리 (단일 책임 원칙)
  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        _navigateToEdit(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref);
        break;
    }
  }

  /// 수정 화면으로 이동 (단일 책임 원칙)
  void _navigateToEdit(BuildContext context) async {
    final result =
        await context.push<TestPost>('/post_edit', extra: _currentPost);

    // 수정된 데이터가 반환되면 화면 업데이트
    if (result != null) {
      setState(() {
        _currentPost = result;
      });
    }
  }

  /// 삭제 확인 다이얼로그 표시 (단일 책임 원칙)
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('글 삭제'),
        content: const Text('정말로 이 글을 삭제하시겠습니까?\n삭제된 글은 복구할 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deletePost(context, ref);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  /// 글 삭제 실행 (단일 책임 원칙)
  void _deletePost(BuildContext context, WidgetRef ref) {
    ref.read(postProvider.notifier).deletePost(_currentPost.id);
  }
}
