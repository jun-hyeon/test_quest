import 'package:test_quest/community/model/test_post.dart';

abstract class TestPostRepository {
  Future<List<TestPost>> fetchPosts();
  Future<TestPost> getPost(String id);
  Future<void> createPost(TestPost post);
  Future<void> updatePost(String id, TestPost post);
  Future<void> deletePost(String id);
}
