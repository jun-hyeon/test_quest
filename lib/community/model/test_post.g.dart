// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPost _$TestPostFromJson(Map<String, dynamic> json) => _TestPost(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform']),
      type: $enumDecode(_$TestTypeEnumMap, json['type']),
      thumbnailUrl: json['thumbnail_url'] as String?,
      linkUrl: json['link_url'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$TestPostToJson(_TestPost instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'thumbnail_url': instance.thumbnailUrl,
      'link_url': instance.linkUrl,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$TestPlatformEnumMap = {
  TestPlatform.pc: 'PC',
  TestPlatform.mobile: 'Mobile',
  TestPlatform.console: 'Console',
};

const _$TestTypeEnumMap = {
  TestType.cbt: 'CBT',
  TestType.obt: 'OBT',
  TestType.alpha: 'Alpha',
  TestType.beta: 'Beta',
};
