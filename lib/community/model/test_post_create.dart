import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_quest/community/model/test_post.dart';

part 'test_post_create.freezed.dart';
part 'test_post_create.g.dart';

@freezed
abstract class TestPostCreate with _$TestPostCreate {
  factory TestPostCreate({
    required String author,
    required String title,
    required String description,
    required TestPlatform platform,
    required TestType type,
    required String linkUrl,
    String? boardImage,
    required String startDate,
    required String endDate,
  }) = _TestPostRequest;

  factory TestPostCreate.fromJson(Map<String, dynamic> json) =>
      _$TestPostRequestFromJson(json);
}
