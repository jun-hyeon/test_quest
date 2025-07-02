// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignupForm {
  String get email;
  String get password;
  String get nickname;
  String get name;
  String? get profileImage;

  /// Create a copy of SignupForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SignupFormCopyWith<SignupForm> get copyWith =>
      _$SignupFormCopyWithImpl<SignupForm>(this as SignupForm, _$identity);

  /// Serializes this SignupForm to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SignupForm &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, nickname, name, profileImage);

  @override
  String toString() {
    return 'SignupForm(email: $email, password: $password, nickname: $nickname, name: $name, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class $SignupFormCopyWith<$Res> {
  factory $SignupFormCopyWith(
          SignupForm value, $Res Function(SignupForm) _then) =
      _$SignupFormCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      String password,
      String nickname,
      String name,
      String? profileImage});
}

/// @nodoc
class _$SignupFormCopyWithImpl<$Res> implements $SignupFormCopyWith<$Res> {
  _$SignupFormCopyWithImpl(this._self, this._then);

  final SignupForm _self;
  final $Res Function(SignupForm) _then;

  /// Create a copy of SignupForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? nickname = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _SignupForm implements SignupForm {
  _SignupForm(
      {required this.email,
      required this.password,
      required this.nickname,
      required this.name,
      this.profileImage});
  factory _SignupForm.fromJson(Map<String, dynamic> json) =>
      _$SignupFormFromJson(json);

  @override
  final String email;
  @override
  final String password;
  @override
  final String nickname;
  @override
  final String name;
  @override
  final String? profileImage;

  /// Create a copy of SignupForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SignupFormCopyWith<_SignupForm> get copyWith =>
      __$SignupFormCopyWithImpl<_SignupForm>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SignupFormToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SignupForm &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, email, password, nickname, name, profileImage);

  @override
  String toString() {
    return 'SignupForm(email: $email, password: $password, nickname: $nickname, name: $name, profileImage: $profileImage)';
  }
}

/// @nodoc
abstract mixin class _$SignupFormCopyWith<$Res>
    implements $SignupFormCopyWith<$Res> {
  factory _$SignupFormCopyWith(
          _SignupForm value, $Res Function(_SignupForm) _then) =
      __$SignupFormCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      String nickname,
      String name,
      String? profileImage});
}

/// @nodoc
class __$SignupFormCopyWithImpl<$Res> implements _$SignupFormCopyWith<$Res> {
  __$SignupFormCopyWithImpl(this._self, this._then);

  final _SignupForm _self;
  final $Res Function(_SignupForm) _then;

  /// Create a copy of SignupForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? nickname = null,
    Object? name = null,
    Object? profileImage = freezed,
  }) {
    return _then(_SignupForm(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profileImage: freezed == profileImage
          ? _self.profileImage
          : profileImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
