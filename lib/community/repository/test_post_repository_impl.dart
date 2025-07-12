import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/community/repository/test_post_repository.dart';
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
  Future<void> createPost(TestPost post) {
    // TODO: implement createPost
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(String id) {
    // TODO: implement deletePost
    throw UnimplementedError();
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

      return data.data!;
    } on DioException catch (e) {
      log('${e.message}');
      throw '페이지를 불러올 수 없습니다.';
    }
  }

  @override
  Future<TestPost> getPost(String id) {
    // TODO: implement getPost
    throw UnimplementedError();
  }

  @override
  Future<void> updatePost(String id, TestPost post) {
    // TODO: implement updatePost
    throw UnimplementedError();
  }
}
