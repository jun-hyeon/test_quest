import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test_quest/comment/repository/comment_repository.dart';
import 'package:test_quest/comment/repository/comment_repository_impl.dart';
import 'package:test_quest/util/service/firebase_service.dart';

part 'comment_repository_provider.g.dart';

@riverpod
CommentRepository commentRepository(Ref ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return CommentRepositoryImpl(firebaseService);
}
