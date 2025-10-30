import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/repository/firebase/community/test_post_repository.dart';
import 'package:test_quest/util/service/firebase_service.dart';

final communityFirestoreRepositoryProvider =
    Provider<CommunityFirestoreRepositoryImpl>((ref) {
  return CommunityFirestoreRepositoryImpl(ref.read(firebaseServiceProvider));
});

class CommunityFirestoreRepositoryImpl implements TestPostRepository {
  final FirebaseService _firebaseService;
  CommunityFirestoreRepositoryImpl(this._firebaseService);

  @override
  Future<void> createPost(TestPost post) async {
    await _firebaseService.firestore
        .collection('posts')
        .doc(post.id)
        .set(post.toJson());
  }

  @override
  Future<TestPost> getPost(String id) async {
    final doc =
        await _firebaseService.firestore.collection('posts').doc(id).get();
    if (doc.data() == null) {
      throw Exception('게시글을 찾을 수 없습니다.');
    }
    return TestPost.fromJson(doc.data()!);
  }

  @override
  Future<void> updatePost(TestPost post) async {
    await _firebaseService.firestore
        .collection('posts')
        .doc(post.id)
        .update(post.toJson());
  }

  @override
  Future<TestPostPagination> fetchPosts({
    String? lastId,
    DateTime? lastCreateAt,
    String? keyword,
    int pageSize = 5,
    String sortOrder = 'latest',
  }) async {
    try {
      log('[Community] 포스트 조회 시작 - keyword: $keyword, pageSize: $pageSize, sortOrder: $sortOrder');

      Query query = _firebaseService.firestore.collection('posts');

      // 키워드가 있으면 검색 쿼리 구성
      if (keyword != null && keyword.isNotEmpty) {
        log('[Community] 키워드 검색 모드: $keyword');
        // Firestore 텍스트 검색은 복합 인덱스가 필요합니다
        // 간단한 접근: title 필드로 시작하는 문서 검색
        final keywordLower = keyword.toLowerCase();
        query = query
            .where('title', isGreaterThanOrEqualTo: keywordLower)
            .where('title', isLessThan: '$keywordLower\uf8ff');
      }

      // 정렬
      if (sortOrder == 'latest') {
        query = query.orderBy('createdAt', descending: true);
      } else {
        query = query.orderBy('createdAt', descending: false);
      }

      // 페이지네이션: lastCreateAt이 있으면 해당 시점 이후부터 가져오기
      if (lastCreateAt != null) {
        log('[Community] 페이지네이션: lastCreateAt = $lastCreateAt');
        query = query.startAfter([lastCreateAt]);
      }

      // limit + 1로 요청하여 hasNext 판단
      query = query.limit(pageSize + 1);

      final snapshot = await query.get();

      log('[Community] 조회된 문서 수: ${snapshot.docs.length}');

      // hasNext 판단: 실제로 받은 문서가 limit보다 많으면 다음 페이지가 있음
      final hasNextPage = snapshot.docs.length > pageSize;

      // 실제로는 pageSize만큼만 사용
      final docsToUse =
          hasNextPage ? snapshot.docs.take(pageSize).toList() : snapshot.docs;

      final posts = docsToUse.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TestPost.fromJson({
          'id': doc.id,
          ...data,
        });
      }).toList();

      log('[Community] 포스트 조회 완료 - posts: ${posts.length}개, hasNext: $hasNextPage');

      // lastCreateAt 업데이트를 위한 정보 로깅
      if (posts.isNotEmpty) {
        log('[Community] 마지막 포스트 createdAt: ${posts.last.createdAt}');
      }

      return TestPostPagination(
        posts: posts,
        hasNext: hasNextPage,
      );
    } catch (e, stackTrace) {
      log('[Community] 포스트 조회 실패: $e');
      log('[Community] 스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String id) async {
    await _firebaseService.firestore.collection('posts').doc(id).delete();
  }

  Future<String> generatePostId() async {
    return _firebaseService.firestore.collection('posts').doc().id;
  }
}
