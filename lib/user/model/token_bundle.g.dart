// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../auth/model/token_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenBundle _$TokenBundleFromJson(Map<String, dynamic> json) => _TokenBundle(
      access: TokenInfo.fromJson(json['access'] as Map<String, dynamic>),
      refresh: TokenInfo.fromJson(json['refresh'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TokenBundleToJson(_TokenBundle instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };
