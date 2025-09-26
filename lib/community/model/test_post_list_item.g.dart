// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostListItem _$TestPostListItemFromJson(Map<String, dynamic> json) =>
    _TestPostListItem(
      id: json['id'] as String,
      title: json['title'] as String,
      nickname: json['nickname'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform'],
          unknownValue: TestPlatform.unknown),
      type: $enumDecode(_$TestTypeEnumMap, json['type'],
          unknownValue: TestType.unknown),
      views: (json['views'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createAt'] as String),
    );

Map<String, dynamic> _$TestPostListItemToJson(_TestPostListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'nickname': instance.nickname,
      'thumbnailUrl': instance.thumbnailUrl,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'views': instance.views,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createAt': instance.createdAt.toIso8601String(),
    };

const _$TestPlatformEnumMap = {
  TestPlatform.pc: 'pc',
  TestPlatform.mobile: 'mobile',
  TestPlatform.console: 'console',
  TestPlatform.unknown: 'unknown',
};

const _$TestTypeEnumMap = {
  TestType.cbt: 'cbt',
  TestType.obt: 'obt',
  TestType.alpha: 'alpha',
  TestType.beta: 'beta',
  TestType.unknown: 'unknown',
};
