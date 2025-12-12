import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_quest/comment/provider/comment_repository_provider.dart';

part 'comment_notifier_provider.g.dart';

@riverpod
class CommentNotifier extends _$CommentNotifier {
  @override
  FutureOr<void> build() {
    // 초기 상태 설정 또는 초기화 작업 수행
  }

  Future<void> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    // 댓글 추가 로직 구현
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      // 실제 댓글 추가 로직 수행
      final repository = ref.read(commentRepositoryProvider);
      await repository.addComment(
        postId: postId,
        content: content,
        parentCommentId: parentCommentId,
      );
    });
  }

  Future<void> editComment({
    required String postId,
    required String commentId,
    required String content,
  }) async {
    // 댓글 수정 로직 구현
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(commentRepositoryProvider);
      await repository.editComment(
        postId: postId,
        commentId: commentId,
        content: content,
      );
    });
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    // 댓글 삭제 로직 구현
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(commentRepositoryProvider);
      await repository.deleteComment(postId: postId, commentId: commentId);
    });
  }
}
