import 'package:test_quest/comment/model/comment_model.dart';

abstract class CommentRepository {
  /// 특정 게시글의 댓글 목록 조회 (실시간 스트림)
  Stream<List<CommentModel>> watchComments(String postId);

  /// 댓글 작성
  Future<void> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  });

  /// 댓글 수정
  Future<void> editComment({
    required String postId,
    required String commentId,
    required String content,
  });

  /// 댓글 삭제
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  });

  /// 특정 댓글 조회
  Future<CommentModel?> getComment({
    required String postId,
    required String commentId,
  });
}
