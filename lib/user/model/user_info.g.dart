// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => _UserInfo(
      uid: json['uid'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      profileUrl: json['profileUrl'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(_UserInfo instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'nickname': instance.nickname,
      'profileUrl': instance.profileUrl,
    };
