// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => _UserInfo(
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(_UserInfo instance) => <String, dynamic>{
      'name': instance.name,
      'nickname': instance.nickname,
      'profileImg': instance.profileImg,
    };
