// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostRequest _$TestPostRequestFromJson(Map<String, dynamic> json) =>
    _TestPostRequest(
      userId: json['userId'] as String,
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      platform: $enumDecode(_$TestPlatformEnumMap, json['platform']),
      type: $enumDecode(_$TestTypeEnumMap, json['type']),
      linkUrl: json['linkUrl'] as String,
      boardImage: json['boardImage'] as String?,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$TestPostRequestToJson(_TestPostRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'author': instance.author,
      'title': instance.title,
      'description': instance.description,
      'platform': _$TestPlatformEnumMap[instance.platform]!,
      'type': _$TestTypeEnumMap[instance.type]!,
      'linkUrl': instance.linkUrl,
      'boardImage': instance.boardImage,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
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
