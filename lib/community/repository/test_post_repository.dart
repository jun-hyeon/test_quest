import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_create.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/community/model/test_post_update.dart';

abstract class TestPostRepository {
  Future<TestPostPagination> fetchPosts({
    String? lastId,
    DateTime? lastCreateAt,
    String? keyword,
    int pageSize = 5,
    String sortOrder = 'latest',
  });
  Future<TestPost> getPost(String id);
  Future<void> createPost(TestPostCreate post);
  Future<void> updatePost(String id, TestPostUpdate post);
  Future<void> deletePost(String id);
}
