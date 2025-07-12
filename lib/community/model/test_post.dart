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
  @JsonValue('unknown')
  unknown,
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
  @JsonValue('unknown')
  unknown,
}

@freezed
abstract class TestPost with _$TestPost {
  factory TestPost({
    required String id,
    required String title,
    required String author,
    required String nickname,
    required String description,
    @JsonKey(unknownEnumValue: TestPlatform.unknown)
    required TestPlatform platform,
    @JsonKey(unknownEnumValue: TestType.unknown) required TestType type,
    required int views,
    String? thumbnailUrl,
    required String linkUrl,
    @JsonKey(name: 'startDate') required DateTime startDate,
    @JsonKey(name: 'endDate') required DateTime endDate,
    @JsonKey(name: 'createAt') required DateTime createdAt,
    required String recruitStatus,
  }) = _TestPost;

  factory TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);
}
