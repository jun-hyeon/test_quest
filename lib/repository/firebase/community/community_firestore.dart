import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/repository/firebase/community/test_post_repository.dart';
import 'package:test_quest/util/service/firebase_service.dart';

final communityFirestoreRepositoryProvider =
    Provider<CommunityFirestoreRepositoryImpl>((ref) {
      return CommunityFirestoreRepositoryImpl(
        ref.read(firebaseServiceProvider),
      );
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
    final doc = await _firebaseService.firestore
        .collection('posts')
        .doc(id)
        .get();
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
      log(
        '[Community] 포스트 조회 시작 - keyword: $keyword, pageSize: $pageSize, sortOrder: $sortOrder, lastId: $lastId',
      );

      // 키워드가 있으면 키워드 검색 쿼리, 없으면 일반 쿼리
      var query = _buildQuery(keyword: keyword);

      // 정렬
      if (sortOrder == 'latest') {
        query = query.orderBy('createdAt', descending: true);
      } else {
        query = query.orderBy('createdAt', descending: false);
      }

      // 쿼리 커서 사용: lastId가 있으면 해당 문서의 DocumentSnapshot을 사용
      // 문서 참조: https://firebase.google.com/docs/firestore/query-data/query-cursors
      DocumentSnapshot? lastDocumentSnapshot;
      if (lastId != null && lastId.isNotEmpty) {
        try {
          final lastDoc = await _firebaseService.firestore
              .collection('posts')
              .doc(lastId)
              .get();

          if (lastDoc.exists) {
            lastDocumentSnapshot = lastDoc;
            log('[Community] 쿼리 커서 사용: lastDocumentSnapshot (${lastDoc.id})');
            query = query.startAfterDocument(lastDocumentSnapshot);
          } else {
            log('[Community] lastId 문서를 찾을 수 없음: $lastId, lastCreateAt 사용');
            // 문서를 찾을 수 없으면 lastCreateAt 사용
            if (lastCreateAt != null) {
              query = query.startAfter([lastCreateAt]);
            }
          }
        } catch (e) {
          log('[Community] lastId로 문서 가져오기 실패: $e, lastCreateAt 사용');
          // 에러 발생 시 lastCreateAt 사용
          if (lastCreateAt != null) {
            query = query.startAfter([lastCreateAt]);
          }
        }
      } else if (lastCreateAt != null) {
        // lastId가 없고 lastCreateAt만 있는 경우
        log('[Community] 페이지네이션: lastCreateAt = $lastCreateAt');
        query = query.startAfter([lastCreateAt]);
      }

      // 키워드 검색의 경우 더 많은 데이터를 가져와서 클라이언트에서 필터링
      // (부분 문자열 포함 검색을 위해 - 첫 글자가 같은 모든 문서를 가져옴)
      final limitSize = (keyword != null && keyword.isNotEmpty)
          ? (pageSize + 1) *
                5 // 키워드 검색 시 5배 더 가져옴 (포함 검색을 위해)
          : pageSize + 1;

      query = query.limit(limitSize);

      final snapshot = await query.get();

      log('[Community] 조회된 문서 수: ${snapshot.docs.length}');

      // 키워드 검색의 경우 클라이언트에서 부분 문자열 포함 검색 수행
      List<QueryDocumentSnapshot> filteredDocs = snapshot.docs;
      if (keyword != null && keyword.isNotEmpty) {
        final keywordLower = keyword.toLowerCase();
        filteredDocs = snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final title = (data['title'] as String?)?.toLowerCase() ?? '';
          final nickname = (data['nickname'] as String?)?.toLowerCase() ?? '';
          // title 또는 nickname에 키워드가 포함되어 있는지 확인
          return title.contains(keywordLower) ||
              nickname.contains(keywordLower);
        }).toList();
        log('[Community] 클라이언트 필터링 후 문서 수: ${filteredDocs.length}개');
      }

      // hasNext 판단: 실제로 받은 문서가 limit보다 많으면 다음 페이지가 있음
      final hasNextPage = filteredDocs.length > pageSize;

      // 실제로는 pageSize만큼만 사용
      final docsToUse = hasNextPage
          ? filteredDocs.take(pageSize).toList()
          : filteredDocs;

      final posts = docsToUse.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TestPost.fromJson({'id': doc.id, ...data});
      }).toList();

      log(
        '[Community] 포스트 조회 완료 - posts: ${posts.length}개, hasNext: $hasNextPage',
      );

      // 마지막 문서 정보 로깅 (다음 쿼리 커서를 위해)
      if (posts.isNotEmpty) {
        final lastPost = posts.last;
        log(
          '[Community] 마지막 포스트 - id: ${lastPost.id}, createdAt: ${lastPost.createdAt}',
        );
        log('[Community] 다음 페이지네이션을 위해 lastId를 ${lastPost.id}로 설정하세요');
      }

      return TestPostPagination(posts: posts, hasNext: hasNextPage);
    } catch (e, stackTrace) {
      log('[Community] 포스트 조회 실패: $e');
      log('[Community] 스택 트레이스: $stackTrace');
      rethrow;
    }
  }

  /// 키워드 검색 쿼리 생성 (포함 검색을 위한 접두사 쿼리)
  /// 참조: https://firebase.google.com/docs/firestore/query-data/queries?hl=ko
  /// 주의: Firestore는 부분 문자열 검색을 직접 지원하지 않으므로,
  /// 키워드의 첫 글자로 시작하는 문서들을 가져온 후 클라이언트에서 포함 검색 수행
  Query _buildQuery({String? keyword}) {
    // 키워드가 없으면 일반 쿼리
    if (keyword == null || keyword.isEmpty) {
      return _firebaseService.firestore.collection('posts');
    }

    log('[Community] 키워드 검색 모드: $keyword (title, nickname 포함 검색)');
    final keywordLower = keyword.toLowerCase();
    final firstChar = keywordLower.isNotEmpty ? keywordLower[0] : '';
    final nextChar = firstChar.isEmpty
        ? '\uf8ff'
        : String.fromCharCode(firstChar.codeUnitAt(0) + 1);

    // Firestore Filter.or() 쿼리를 사용하여 title 또는 nickname 검색
    // 키워드의 첫 글자로 시작하는 모든 문서를 가져옴 (부분 문자열 검색을 위해)
    // 이후 클라이언트에서 실제 포함 검색 수행
    return _firebaseService.firestore
        .collection('posts')
        .where(
          Filter.or(
            Filter.and(
              Filter('title', isGreaterThanOrEqualTo: firstChar),
              Filter('title', isLessThan: nextChar),
            ),
            Filter.and(
              Filter('nickname', isGreaterThanOrEqualTo: firstChar),
              Filter('nickname', isLessThan: nextChar),
            ),
          ),
        );
  }

  @override
  Future<void> deletePost(String id) async {
    await _firebaseService.firestore.collection('posts').doc(id).delete();
  }

  Future<String> generatePostId() async {
    return _firebaseService.firestore.collection('posts').doc().id;
  }
}
