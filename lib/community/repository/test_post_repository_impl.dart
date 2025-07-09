import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/repository/test_post_repository.dart';
import 'package:test_quest/util/provider/dio_provider.dart';

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
  Future<List<TestPost>> fetchPosts() {
    // TODO: implement fetchPosts
    throw UnimplementedError();
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
