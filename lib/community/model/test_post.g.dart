// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPost _$TestPostFromJson(Map<String, dynamic> json) => _TestPost(
      id: json['id'] as String,
      title: json['title'] as String,
      auth: json['auth'] as String,
      description: json['description'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform']),
      type: $enumDecode(_$TestTypeEnumMap, json['type']),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      linkUrl: json['linkUrl'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TestPostToJson(_TestPost instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'auth': instance.auth,
      'description': instance.description,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'thumbnailUrl': instance.thumbnailUrl,
      'linkUrl': instance.linkUrl,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
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
