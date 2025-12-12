import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_quest/comment/model/comment_model.dart';
import 'package:test_quest/comment/repository/comment_repository.dart';
import 'package:test_quest/util/service/firebase_service.dart';

class CommentRepositoryImpl implements CommentRepository {
  final FirebaseService _firebaseService;

  CommentRepositoryImpl(this._firebaseService);

  FirebaseFirestore get _firestore => _firebaseService.firestore;

  CollectionReference _commentsRef(String postId) {
    return _firestore.collection('posts').doc(postId).collection('comments');
  }

  @override
  Future<void> addComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다.');
      }
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      final batch = _firestore.batch();
      final commentRef = _commentsRef(postId).doc();

      final comment = CommentModel(
        id: commentRef.id,
        postId: postId,
        userId: user.uid,
        userName: userData?['nickname'] ?? '익명',
        userProfileUrl: userData?['profileUrl'],
        content: content,
        createdAt: DateTime.now(),
        updatedAt: null,
        parentCommentId: parentCommentId,
      );

      batch.set(commentRef, comment.toJson());

      final postRef = _firestore.collection('posts').doc(postId);
      batch.update(postRef, {'commentCount': FieldValue.increment(1)});
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('댓글 작성에 실패했습니다: ${e.message}');
    }
  }

  @override
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    final user = _firebaseService.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }

    try {
      final commentDoc = await _commentsRef(postId).doc(commentId).get();
      final commentData = commentDoc.data() as Map<String, dynamic>?;

      if (commentData?['userId'] != user.uid) {
        throw Exception('본인의 댓글만 삭제할 수 있습니다.');
      }

      final batch = _firestore.batch();
      final commentRef = _commentsRef(postId).doc(commentId);
      batch.delete(commentRef);
      final postRef = _firestore.collection('posts').doc(postId);
      batch.update(postRef, {'commentCount': FieldValue.increment(-1)});
      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('댓글 삭제에 실패했습니다: ${e.message}');
    }
  }

  @override
  Future<void> editComment({
    required String postId,
    required String commentId,
    required String content,
  }) async {
    final user = _firebaseService.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }

    try {
      final commentDoc = await _commentsRef(postId).doc(commentId).get();
      final commentData = commentDoc.data() as Map<String, dynamic>?;

      if (commentData?['userId'] != user.uid) {
        throw Exception('본인의 댓글만 수정할 수 있습니다.');
      }

      await _commentsRef(postId).doc(commentId).update({
        'content': content,
        'updatedAt': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      throw Exception('댓글 수정에 실패했습니다: ${e.message}');
    }
  }

  @override
  Future<CommentModel?> getComment({
    required String postId,
    required String commentId,
  }) async {
    final user = _firebaseService.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }
    try {
      final commentDoc = await _commentsRef(postId).doc(commentId).get();
      if (!commentDoc.exists) {
        return null;
      }
      return CommentModel.fromJson(commentDoc.data() as Map<String, dynamic>);
    } on FirebaseException catch (e) {
      throw Exception('댓글 조회에 실패했습니다: ${e.message}');
    }
  }

  @override
  Stream<List<CommentModel>> watchComments(String postId) {
    return _commentsRef(postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    CommentModel.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
