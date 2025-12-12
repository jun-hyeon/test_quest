import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_quest/comment/model/comment_model.dart';
import 'package:test_quest/comment/provider/comment_repository_provider.dart';

part 'comment_list_provider.g.dart';

@riverpod
Stream<List<CommentModel>> commentList(Ref ref, String postId) {
  final commentRepository = ref.watch(commentRepositoryProvider);
  return commentRepository.watchComments(postId);
}
