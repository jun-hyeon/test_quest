import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/repository/test_post_repository_impl.dart';

/// 게시글 ID를 기반으로 상세 정보를 제공하는 Provider
final postDetailProvider = AsyncNotifierProvider.autoDispose
    .family<PostDetailNotifier, TestPost, String>(
  PostDetailNotifier.new,
);

/// 게시글 상세 정보 Notifier
class PostDetailNotifier extends AsyncNotifier<TestPost> {
  late final repository = ref.read(testPostRepositoryProvider);
  PostDetailNotifier(this.postId);
  final String postId;
  @override
  Future<TestPost> build() async {
    log('[PostDetailNotifier] build 호출: postId=$postId');
    return _fetchPost(postId);
  }

  /// 게시글 정보 로드
  Future<TestPost> _fetchPost(String postId) async {
    try {
      log('[PostDetailNotifier] _fetchPost 호출: postId=$postId');
      final post = await repository.getPost(postId);
      log('[PostDetailNotifier] 게시글 로드 성공: ${post.title}');
      return post;
    } catch (e, stackTrace) {
      log('[PostDetailNotifier] 게시글 로드 실패', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 게시글 정보 새로고침
  Future<void> refresh(String postId) async {
    log('[PostDetailNotifier] refresh 호출: postId=$postId');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPost(postId));
  }
}
