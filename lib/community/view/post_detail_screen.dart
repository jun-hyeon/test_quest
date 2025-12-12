import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_quest/comment/view/comment_input_widget.dart';
import 'package:test_quest/comment/view/comment_section_widget.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/post_detail_provider.dart';
import 'package:test_quest/community/provider/post_provider.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(postProvider, (previous, next) {
      if (next is PostSuccess) {
        if (mounted) {
          TestQuestSnackbar.show(context, '글이 성공적으로 삭제되었습니다.', isError: false);
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
    final postDetailAsync = ref.watch(postDetailProvider(widget.postId));
    final deleteState = ref.watch(postProvider);
    final isDeleting = deleteState is PostLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('게시글 상세')),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            postDetailAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (post) => _buildPostDetail(context, post, isDeleting),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(error.toString()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(postDetailProvider(widget.postId).notifier)
                          .refresh(widget.postId),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CommentInputWidget(postId: widget.postId),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostDetail(
    BuildContext context,
    TestPost post,
    bool isDeleting,
  ) {
    final currentUser = ref.watch(currentUserProvider);

    // Firebase Auth의 uid를 사용하여 작성자 확인
    final isAuthor =
        currentUser?.uid == post.userId ||
        currentUser?.nickname == post.nickname;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          if (post.thumbnailUrl != null && post.thumbnailUrl!.isNotEmpty)
            Hero(
              tag: 'post_thumbnail_${post.id}',
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: post.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return const Placeholder(
                        strokeWidth: 1,
                        fallbackHeight: 200,
                      );
                    },
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              if (isAuthor)
                PopupMenuButton<String>(
                  onSelected: (action) =>
                      _handleMenuAction(context, action, post),
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
                      enabled: !isDeleting,
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
          // 나머지 UI 코드는 동일...
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
          Text('테스트 기간', style: Theme.of(context).textTheme.titleMedium),
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
          // 리치 콘텐츠 표시
          if (post.content != null && post.content!.isNotEmpty)
            _buildRichContent(post.content!)
          else
            Text(
              post.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _openRelatedLink(post),
            child: const Text('관련 링크 열기'),
          ),

          const SizedBox(height: 32),
          const Divider(thickness: 8, height: 32),

          //댓글
          CommentSectionWidget(postId: widget.postId),

          // 입력창 공간 확보
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// 리치 콘텐츠 빌더 (읽기 전용 Quill Editor)
  Widget _buildRichContent(List<dynamic> content) {
    try {
      final delta = Delta.fromJson(content);
      final controller = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );

      return QuillEditor(
        controller: controller,
        scrollController: ScrollController(),
        focusNode: FocusNode(),
        config: QuillEditorConfig(
          padding: EdgeInsets.zero,
          showCursor: false,
          embedBuilders: FlutterQuillEmbeds.editorBuilders(),
        ),
      );
    } catch (e) {
      // Delta 파싱 실패 시 fallback
      return Text(
        '콘텐츠를 표시할 수 없습니다.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
      );
    }
  }

  /// 관련 링크 열기
  Future<void> _openRelatedLink(TestPost post) async {
    final Uri url = Uri.parse(post.linkUrl);
    try {
      final bool canLaunch = await canLaunchUrl(url);
      if (!mounted) return;
      if (!canLaunch) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('링크를 열 수 없습니다.')));
        return;
      }
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
    }
  }

  /// 메뉴 액션 처리
  void _handleMenuAction(BuildContext context, String action, TestPost post) {
    switch (action) {
      case 'edit':
        _navigateToEdit(context, post);
        break;
      case 'delete':
        _showDeleteConfirmation(context, post);
        break;
    }
  }

  /// 수정 화면으로 이동
  void _navigateToEdit(BuildContext context, TestPost post) async {
    final result = await context.push<TestPost>('/post_edit', extra: post);

    // 수정된 데이터가 반환되면 화면 업데이트
    if (result != null) {
      setState(() {
        post = result;
      });
    }
  }

  /// 삭제 확인 다이얼로그 표시
  void _showDeleteConfirmation(BuildContext context, TestPost post) {
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
              _deletePost(context, post);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  /// 글 삭제 실행
  void _deletePost(BuildContext context, TestPost post) {
    ref.read(postProvider.notifier).deletePost(post.id);
  }
}
