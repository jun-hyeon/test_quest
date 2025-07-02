import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_post.freezed.dart';
part 'test_post.g.dart';

@JsonEnum()
enum TestPlatform {
  @JsonValue('PC')
  pc,
  @JsonValue('Mobile')
  mobile,
  @JsonValue('Console')
  console,
}

@JsonEnum()
enum TestType {
  @JsonValue('CBT')
  cbt,
  @JsonValue('OBT')
  obt,
  @JsonValue('Alpha')
  alpha,
  @JsonValue('Beta')
  beta,
}

@freezed
abstract class TestPost with _$TestPost {
  factory TestPost({
    required String? id,
    required String title,
    required String description,
    required TestPlatform platform,
    required TestType type,
    String? thumbnailUrl,
    String? linkUrl,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime createdAt,
  }) = _TestPost;

  factory TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);
}
