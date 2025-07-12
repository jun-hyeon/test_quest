// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPost _$TestPostFromJson(Map<String, dynamic> json) => _TestPost(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      nickname: json['nickname'] as String,
      description: json['description'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform'],
          unknownValue: TestPlatform.unknown),
      type: $enumDecode(_$TestTypeEnumMap, json['type'],
          unknownValue: TestType.unknown),
      views: (json['views'] as num).toInt(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      linkUrl: json['linkUrl'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createAt'] as String),
      recruitStatus: json['recruitStatus'] as String,
    );

Map<String, dynamic> _$TestPostToJson(_TestPost instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'nickname': instance.nickname,
      'description': instance.description,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'views': instance.views,
      'thumbnailUrl': instance.thumbnailUrl,
      'linkUrl': instance.linkUrl,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createAt': instance.createdAt.toIso8601String(),
      'recruitStatus': instance.recruitStatus,
    };

const _$TestPlatformEnumMap = {
  TestPlatform.pc: 'PC',
  TestPlatform.mobile: 'Mobile',
  TestPlatform.console: 'Console',
  TestPlatform.unknown: 'unknown',
};

const _$TestTypeEnumMap = {
  TestType.cbt: 'CBT',
  TestType.obt: 'OBT',
  TestType.alpha: 'Alpha',
  TestType.beta: 'Beta',
  TestType.unknown: 'unknown',
};
