import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_quest/community/model/test_post.dart';

part 'test_post_list_item.freezed.dart';
part 'test_post_list_item.g.dart';

@freezed
abstract class TestPostListItem with _$TestPostListItem {
  factory TestPostListItem({
    required String id,
    required String title,
    required String nickname,
    required String thumbnailUrl,
    @JsonKey(unknownEnumValue: TestPlatform.unknown)
    required TestPlatform platform,
    @JsonKey(unknownEnumValue: TestType.unknown) required TestType type,
    required int views,
    @JsonKey(name: 'startDate') required DateTime startDate,
    @JsonKey(name: 'endDate') required DateTime endDate,
    @JsonKey(name: 'createAt') required DateTime createdAt,
  }) = _TestPostListItem;

  factory TestPostListItem.fromJson(Map<String, dynamic> json) =>
      _$TestPostListItemFromJson(json);
}
