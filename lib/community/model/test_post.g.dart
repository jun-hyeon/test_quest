// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPost _$TestPostFromJson(Map<String, dynamic> json) => _TestPost(
  id: json['id'] as String,
  title: json['title'] as String,
  userId: json['userId'] as String,
  nickname: json['nickname'] as String,
  description: json['description'] as String,
  platform: $enumDecode(
    _$TestPlatformEnumMap,
    json['platform'],
    unknownValue: TestPlatform.unknown,
  ),
  type: $enumDecode(
    _$TestTypeEnumMap,
    json['type'],
    unknownValue: TestType.unknown,
  ),
  views: (json['views'] as num).toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String?,
  linkUrl: json['linkUrl'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  recruitStatus: json['recruitStatus'] as String,
);

Map<String, dynamic> _$TestPostToJson(_TestPost instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'userId': instance.userId,
  'nickname': instance.nickname,
  'description': instance.description,
  'platform': _$TestPlatformEnumMap[instance.platform]!,
  'type': _$TestTypeEnumMap[instance.type]!,
  'views': instance.views,
  'thumbnailUrl': instance.thumbnailUrl,
  'linkUrl': instance.linkUrl,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'recruitStatus': instance.recruitStatus,
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
