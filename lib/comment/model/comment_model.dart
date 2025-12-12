import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

@freezed
sealed class CommentModel with _$CommentModel {
  const factory CommentModel({
    required String id,
    required String postId,
    required String userId,
    required String userName,
    String? userProfileUrl,
    required String content,
    required DateTime createdAt,
    DateTime? updatedAt,
    String? parentCommentId,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}
