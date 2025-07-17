import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_post_update.freezed.dart';
part 'test_post_update.g.dart';

@freezed
abstract class TestPostUpdate with _$TestPostUpdate {
  factory TestPostUpdate({
    required String id,
    required String title,
    required String description,
    String? boardImage,
  }) = _TestPostUpdate;

  factory TestPostUpdate.fromJson(Map<String, dynamic> json) =>
      _$TestPostUpdateFromJson(json);
}
