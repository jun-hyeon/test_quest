import 'package:test_quest/community/model/test_post.dart';

sealed class PaginationState {
  const PaginationState();
}

class PaginationLoading extends PaginationState {
  const PaginationLoading();
}

class PaginationRefreshing extends PaginationState {
  final List<TestPost> previousPosts;
  const PaginationRefreshing(this.previousPosts);
}

class PaginationData extends PaginationState {
  final List<TestPost> posts;
  final bool hasNext;
  final bool isFetching;

  const PaginationData({
    required this.posts,
    required this.hasNext,
    required this.isFetching,
  });
}

class PaginationError extends PaginationState {
  final Object error;
  final StackTrace stackTrace;
  const PaginationError(this.error, this.stackTrace);
}
