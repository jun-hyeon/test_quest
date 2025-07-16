// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../auth/model/token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => _TokenInfo(
      token: json['token'] as String,
      expiresIn: (json['expiresIn'] as num).toInt(),
    );

Map<String, dynamic> _$TokenInfoToJson(_TokenInfo instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiresIn': instance.expiresIn,
    };

_AccessResponse _$AccessResponseFromJson(Map<String, dynamic> json) =>
    _AccessResponse(
      access: TokenInfo.fromJson(json['access'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccessResponseToJson(_AccessResponse instance) =>
    <String, dynamic>{
      'access': instance.access,
    };
