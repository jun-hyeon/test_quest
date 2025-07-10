// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenInfo {
  String get token;
  int get expiresIn;

  /// Create a copy of TokenInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<TokenInfo> get copyWith =>
      _$TokenInfoCopyWithImpl<TokenInfo>(this as TokenInfo, _$identity);

  /// Serializes this TokenInfo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TokenInfo &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, expiresIn);

  @override
  String toString() {
    return 'TokenInfo(token: $token, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class $TokenInfoCopyWith<$Res> {
  factory $TokenInfoCopyWith(TokenInfo value, $Res Function(TokenInfo) _then) =
      _$TokenInfoCopyWithImpl;
  @useResult
  $Res call({String token, int expiresIn});
}

/// @nodoc
class _$TokenInfoCopyWithImpl<$Res> implements $TokenInfoCopyWith<$Res> {
  _$TokenInfoCopyWithImpl(this._self, this._then);

  final TokenInfo _self;
  final $Res Function(TokenInfo) _then;

  /// Create a copy of TokenInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [TokenInfo].
extension TokenInfoPatterns on TokenInfo {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TokenInfo value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokenInfo() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TokenInfo value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenInfo():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TokenInfo value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenInfo() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String token, int expiresIn)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TokenInfo() when $default != null:
        return $default(_that.token, _that.expiresIn);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String token, int expiresIn) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenInfo():
        return $default(_that.token, _that.expiresIn);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String token, int expiresIn)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TokenInfo() when $default != null:
        return $default(_that.token, _that.expiresIn);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TokenInfo implements TokenInfo {
  _TokenInfo({required this.token, required this.expiresIn});
  factory _TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  @override
  final String token;
  @override
  final int expiresIn;

  /// Create a copy of TokenInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TokenInfoCopyWith<_TokenInfo> get copyWith =>
      __$TokenInfoCopyWithImpl<_TokenInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TokenInfoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TokenInfo &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, expiresIn);

  @override
  String toString() {
    return 'TokenInfo(token: $token, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class _$TokenInfoCopyWith<$Res>
    implements $TokenInfoCopyWith<$Res> {
  factory _$TokenInfoCopyWith(
          _TokenInfo value, $Res Function(_TokenInfo) _then) =
      __$TokenInfoCopyWithImpl;
  @override
  @useResult
  $Res call({String token, int expiresIn});
}

/// @nodoc
class __$TokenInfoCopyWithImpl<$Res> implements _$TokenInfoCopyWith<$Res> {
  __$TokenInfoCopyWithImpl(this._self, this._then);

  final _TokenInfo _self;
  final $Res Function(_TokenInfo) _then;

  /// Create a copy of TokenInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
  }) {
    return _then(_TokenInfo(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$AccessResponse {
  TokenInfo get access;

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccessResponseCopyWith<AccessResponse> get copyWith =>
      _$AccessResponseCopyWithImpl<AccessResponse>(
          this as AccessResponse, _$identity);

  /// Serializes this AccessResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccessResponse &&
            (identical(other.access, access) || other.access == access));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access);

  @override
  String toString() {
    return 'AccessResponse(access: $access)';
  }
}

/// @nodoc
abstract mixin class $AccessResponseCopyWith<$Res> {
  factory $AccessResponseCopyWith(
          AccessResponse value, $Res Function(AccessResponse) _then) =
      _$AccessResponseCopyWithImpl;
  @useResult
  $Res call({TokenInfo access});

  $TokenInfoCopyWith<$Res> get access;
}

/// @nodoc
class _$AccessResponseCopyWithImpl<$Res>
    implements $AccessResponseCopyWith<$Res> {
  _$AccessResponseCopyWithImpl(this._self, this._then);

  final AccessResponse _self;
  final $Res Function(AccessResponse) _then;

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
  }) {
    return _then(_self.copyWith(
      access: null == access
          ? _self.access
          : access // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
    ));
  }

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get access {
    return $TokenInfoCopyWith<$Res>(_self.access, (value) {
      return _then(_self.copyWith(access: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AccessResponse].
extension AccessResponsePatterns on AccessResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AccessResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccessResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AccessResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccessResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AccessResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccessResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(TokenInfo access)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccessResponse() when $default != null:
        return $default(_that.access);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(TokenInfo access) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccessResponse():
        return $default(_that.access);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(TokenInfo access)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccessResponse() when $default != null:
        return $default(_that.access);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccessResponse implements AccessResponse {
  _AccessResponse({required this.access});
  factory _AccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessResponseFromJson(json);

  @override
  final TokenInfo access;

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccessResponseCopyWith<_AccessResponse> get copyWith =>
      __$AccessResponseCopyWithImpl<_AccessResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccessResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccessResponse &&
            (identical(other.access, access) || other.access == access));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access);

  @override
  String toString() {
    return 'AccessResponse(access: $access)';
  }
}

/// @nodoc
abstract mixin class _$AccessResponseCopyWith<$Res>
    implements $AccessResponseCopyWith<$Res> {
  factory _$AccessResponseCopyWith(
          _AccessResponse value, $Res Function(_AccessResponse) _then) =
      __$AccessResponseCopyWithImpl;
  @override
  @useResult
  $Res call({TokenInfo access});

  @override
  $TokenInfoCopyWith<$Res> get access;
}

/// @nodoc
class __$AccessResponseCopyWithImpl<$Res>
    implements _$AccessResponseCopyWith<$Res> {
  __$AccessResponseCopyWithImpl(this._self, this._then);

  final _AccessResponse _self;
  final $Res Function(_AccessResponse) _then;

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? access = null,
  }) {
    return _then(_AccessResponse(
      access: null == access
          ? _self.access
          : access // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
    ));
  }

  /// Create a copy of AccessResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get access {
    return $TokenInfoCopyWith<$Res>(_self.access, (value) {
      return _then(_self.copyWith(access: value));
    });
  }
}

// dart format on
