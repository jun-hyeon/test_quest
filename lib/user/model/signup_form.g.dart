// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignupForm _$SignupFormFromJson(Map<String, dynamic> json) => _SignupForm(
      email: json['email'] as String,
      password: json['password'] as String,
      nickname: json['nickname'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$SignupFormToJson(_SignupForm instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'nickname': instance.nickname,
      'name': instance.name,
      'profileImage': instance.profileImage,
    };
