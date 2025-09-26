// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostPagination _$TestPostPaginationFromJson(Map<String, dynamic> json) =>
    _TestPostPagination(
      gameBoards: (json['gameBoards'] as List<dynamic>)
          .map((e) => TestPostListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['hasNext'] as bool,
    );

Map<String, dynamic> _$TestPostPaginationToJson(_TestPostPagination instance) =>
    <String, dynamic>{
      'gameBoards': instance.gameBoards,
      'hasNext': instance.hasNext,
    };
