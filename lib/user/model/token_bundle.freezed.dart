// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenBundle {
  TokenInfo get access;
  TokenInfo get refresh;

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TokenBundleCopyWith<TokenBundle> get copyWith =>
      _$TokenBundleCopyWithImpl<TokenBundle>(this as TokenBundle, _$identity);

  /// Serializes this TokenBundle to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TokenBundle &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access, refresh);

  @override
  String toString() {
    return 'TokenBundle(access: $access, refresh: $refresh)';
  }
}

/// @nodoc
abstract mixin class $TokenBundleCopyWith<$Res> {
  factory $TokenBundleCopyWith(
          TokenBundle value, $Res Function(TokenBundle) _then) =
      _$TokenBundleCopyWithImpl;
  @useResult
  $Res call({TokenInfo access, TokenInfo refresh});

  $TokenInfoCopyWith<$Res> get access;
  $TokenInfoCopyWith<$Res> get refresh;
}

/// @nodoc
class _$TokenBundleCopyWithImpl<$Res> implements $TokenBundleCopyWith<$Res> {
  _$TokenBundleCopyWithImpl(this._self, this._then);

  final TokenBundle _self;
  final $Res Function(TokenBundle) _then;

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_self.copyWith(
      access: null == access
          ? _self.access
          : access // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
      refresh: null == refresh
          ? _self.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
    ));
  }

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get access {
    return $TokenInfoCopyWith<$Res>(_self.access, (value) {
      return _then(_self.copyWith(access: value));
    });
  }

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get refresh {
    return $TokenInfoCopyWith<$Res>(_self.refresh, (value) {
      return _then(_self.copyWith(refresh: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _TokenBundle implements TokenBundle {
  _TokenBundle({required this.access, required this.refresh});
  factory _TokenBundle.fromJson(Map<String, dynamic> json) =>
      _$TokenBundleFromJson(json);

  @override
  final TokenInfo access;
  @override
  final TokenInfo refresh;

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TokenBundleCopyWith<_TokenBundle> get copyWith =>
      __$TokenBundleCopyWithImpl<_TokenBundle>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TokenBundleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TokenBundle &&
            (identical(other.access, access) || other.access == access) &&
            (identical(other.refresh, refresh) || other.refresh == refresh));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, access, refresh);

  @override
  String toString() {
    return 'TokenBundle(access: $access, refresh: $refresh)';
  }
}

/// @nodoc
abstract mixin class _$TokenBundleCopyWith<$Res>
    implements $TokenBundleCopyWith<$Res> {
  factory _$TokenBundleCopyWith(
          _TokenBundle value, $Res Function(_TokenBundle) _then) =
      __$TokenBundleCopyWithImpl;
  @override
  @useResult
  $Res call({TokenInfo access, TokenInfo refresh});

  @override
  $TokenInfoCopyWith<$Res> get access;
  @override
  $TokenInfoCopyWith<$Res> get refresh;
}

/// @nodoc
class __$TokenBundleCopyWithImpl<$Res> implements _$TokenBundleCopyWith<$Res> {
  __$TokenBundleCopyWithImpl(this._self, this._then);

  final _TokenBundle _self;
  final $Res Function(_TokenBundle) _then;

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? access = null,
    Object? refresh = null,
  }) {
    return _then(_TokenBundle(
      access: null == access
          ? _self.access
          : access // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
      refresh: null == refresh
          ? _self.refresh
          : refresh // ignore: cast_nullable_to_non_nullable
              as TokenInfo,
    ));
  }

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get access {
    return $TokenInfoCopyWith<$Res>(_self.access, (value) {
      return _then(_self.copyWith(access: value));
    });
  }

  /// Create a copy of TokenBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TokenInfoCopyWith<$Res> get refresh {
    return $TokenInfoCopyWith<$Res>(_self.refresh, (value) {
      return _then(_self.copyWith(refresh: value));
    });
  }
}

// dart format on
