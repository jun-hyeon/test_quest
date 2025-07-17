// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_post_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestPostUpdate _$TestPostUpdateFromJson(Map<String, dynamic> json) =>
    _TestPostUpdate(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      boardImage: json['boardImage'] as String?,
    );

Map<String, dynamic> _$TestPostUpdateToJson(_TestPostUpdate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'boardImage': instance.boardImage,
    };
