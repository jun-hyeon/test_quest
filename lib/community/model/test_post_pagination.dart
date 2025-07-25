import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_quest/community/model/test_post.dart';

part 'test_post_pagination.freezed.dart';
part 'test_post_pagination.g.dart';

@freezed
abstract class TestPostPagination with _$TestPostPagination {
  factory TestPostPagination({
    required List<TestPost> gameBoards,
    required bool hasNext,
  }) = _TestPostPagination;

  factory TestPostPagination.fromJson(Map<String, dynamic> json) =>
      _$TestPostPaginationFromJson(json);
}
