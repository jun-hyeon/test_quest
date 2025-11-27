// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostPagination _$TestPostPaginationFromJson(Map<String, dynamic> json) =>
    _TestPostPagination(
      posts: (json['posts'] as List<dynamic>)
          .map((e) => TestPost.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$TestPostPaginationToJson(_TestPostPagination instance) =>
    <String, dynamic>{'posts': instance.posts, 'hasNext': instance.hasNext};
