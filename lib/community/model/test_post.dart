import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_post.freezed.dart';
part 'test_post.g.dart';

@JsonEnum()
enum TestPlatform {
  @JsonValue('pc')
  pc,
  @JsonValue('mobile')
  mobile,
  @JsonValue('console')
  console,
  @JsonValue('unknown')
  unknown,
}

@JsonEnum()
enum TestType {
  @JsonValue('cbt')
  cbt,
  @JsonValue('obt')
  obt,
  @JsonValue('alpha')
  alpha,
  @JsonValue('beta')
  beta,
  @JsonValue('unknown')
  unknown,
}

@freezed
abstract class TestPost with _$TestPost {
  factory TestPost({
    required String id,
    required String title,
    required String userId,
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
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    required String recruitStatus,
    List<dynamic>? content, // Quill Delta JSON 형식
  }) = _TestPost;

  factory TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);
}
