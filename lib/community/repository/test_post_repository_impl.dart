import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_create.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/community/model/test_post_update.dart';
import 'package:test_quest/community/repository/test_post_repository.dart';
import 'package:test_quest/util/extensions/enum_extension.dart';
import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/network/provider/dio_provider.dart';

final testPostRepositoryProvider = Provider<TestPostRepository>((ref) {
  final dio = ref.read(dioProvider);
  return TestPostRepositoryImpl(dio);
});

class TestPostRepositoryImpl implements TestPostRepository {
  final Dio dio;

  TestPostRepositoryImpl(this.dio);

  @override
  Future<void> createPost(TestPostCreate post) async {
    try {
      final formData = FormData.fromMap({
        'title': post.title,
        'description': post.description,
        'platform': post.platform.toPostString(),
        'type': post.type.toPostString(),
        'linkUrl': post.linkUrl,
        'startDate': post.startDate,
        'endDate': post.endDate,
        'recruitStatus': post.recruitStatus,
        if (post.boardImage != null && post.boardImage!.isNotEmpty)
          'boardImage': await MultipartFile.fromFile(
            post.boardImage!,
            filename: '${post.boardImage!.split('/').last}.jpg',
          ),
      });
      log('[TestPostRepository] ${formData.toString()}');
      final response = await dio.post('/gameboard/create', data: formData);
      log('[TestPostRepository] Create response: ${response.data}');
    } on DioException catch (e) {
      log('Failed to create post: ${e.message}');
      throw Exception('게시글 작성에 실패했습니다.');
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      log('[TestPostRepository] Delete post: $id');
      final response = await dio.post(
        '/gameboard/delete',
        queryParameters: {'boardId': id},
      );
      log('[TestPostRepository] Delete response: ${response.data}');
    } on DioException catch (e) {
      log('[TestPostRepository] Delete post error: ${e.message}');
      throw Exception('게시글 삭제에 실패했습니다.');
    }
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
      final response = await dio.get(
        '/gameboard/list',
        queryParameters: {
          if (lastId != null) 'lastId': lastId,
          if (lastCreateAt != null)
            'lastCreateAt': lastCreateAt.toIso8601String(),
          if (keyword != null) 'keyword': keyword,
          'pageSize': pageSize,
          'sortOrder': sortOrder,
        },
      );
      final data = ResponseModel<TestPostPagination>.fromJson(response.data,
          (json) => TestPostPagination.fromJson(json as Map<String, dynamic>));

      if (data.data == null) {
        throw '페이지를 불러올 수 없습니다.';
      }
      log('[TestPostRepository] Fetch posts: ${data.data!}');
      return data.data!;
    } on DioException catch (e) {
      log('[DioException message]${e.message}');
      log('[fetchPosts DioException response] ${e.response}');
      rethrow;
    }
  }

  @override
  Future<TestPost> getPost(String id) async {
    try {
      final response = await dio.get(
        '/gameboard/$id',
      );

      final data = ResponseModel<TestPost>.fromJson(response.data,
          (json) => TestPost.fromJson(json as Map<String, dynamic>));
      log('[TestPostRepository] Get post: ${data.toString()}');
      if (data.data == null) {
        throw '게시글을 불러올 수 없습니다.';
      }

      return data.data!;
    } on DioException catch (e) {
      log('[DioException message]${e.message}');
      log('[getPost DioException response] ${e.response}');
      throw Exception('게시글을 불러오는데 실패했습니다.');
    }
  }

  @override
  Future<void> updatePost(String id, TestPostUpdate post) async {
    try {
      final formData = FormData.fromMap({
        'id': post.id,
        'title': post.title,
        'description': post.description,
        if (post.boardImage != null && post.boardImage!.isNotEmpty)
          'boardImage': await MultipartFile.fromFile(
            post.boardImage!,
            filename: '${post.boardImage!.split('/').last}.jpg',
          ),
      });

      log('[TestPostRepository] Update formData: ${formData.toString()}');
      final response = await dio.post('/gameboard/update', data: formData);
      log('[TestPostRepository] Update response: ${response.data}');
    } on DioException catch (e) {
      log('Failed to update post: ${e.message}');
      throw Exception('게시글 수정에 실패했습니다.');
    }
  }
}
