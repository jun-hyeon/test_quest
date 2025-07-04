import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_quest/community/model/test_post.dart';

part 'test_post_request.freezed.dart';
part 'test_post_request.g.dart';

@freezed
abstract class TestPostRequest with _$TestPostRequest {
  factory TestPostRequest({
    required String userId,
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

  factory TestPostRequest.fromJson(Map<String, dynamic> json) =>
      _$TestPostRequestFromJson(json);
}
