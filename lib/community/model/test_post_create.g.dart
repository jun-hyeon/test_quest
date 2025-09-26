// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostRequest _$TestPostRequestFromJson(Map<String, dynamic> json) =>
    _TestPostRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform']),
      type: $enumDecode(_$TestTypeEnumMap, json['type']),
      linkUrl: json['linkUrl'] as String,
      boardImage: json['boardImage'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      recruitStatus: json['recruitStatus'] as String,
    );

Map<String, dynamic> _$TestPostRequestToJson(_TestPostRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'linkUrl': instance.linkUrl,
      'boardImage': instance.boardImage,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
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
