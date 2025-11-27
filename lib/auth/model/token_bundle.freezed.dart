// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

 TokenInfo get access; TokenInfo get refresh;
/// Create a copy of TokenBundle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenBundleCopyWith<TokenBundle> get copyWith => _$TokenBundleCopyWithImpl<TokenBundle>(this as TokenBundle, _$identity);

  /// Serializes this TokenBundle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenBundle&&(identical(other.access, access) || other.access == access)&&(identical(other.refresh, refresh) || other.refresh == refresh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access,refresh);

@override
String toString() {
  return 'TokenBundle(access: $access, refresh: $refresh)';
}


}

/// @nodoc
abstract mixin class $TokenBundleCopyWith<$Res>  {
  factory $TokenBundleCopyWith(TokenBundle value, $Res Function(TokenBundle) _then) = _$TokenBundleCopyWithImpl;
@useResult
$Res call({
 TokenInfo access, TokenInfo refresh
});


$TokenInfoCopyWith<$Res> get access;$TokenInfoCopyWith<$Res> get refresh;

}
/// @nodoc
class _$TokenBundleCopyWithImpl<$Res>
    implements $TokenBundleCopyWith<$Res> {
  _$TokenBundleCopyWithImpl(this._self, this._then);

  final TokenBundle _self;
  final $Res Function(TokenBundle) _then;

/// Create a copy of TokenBundle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? access = null,Object? refresh = null,}) {
  return _then(_self.copyWith(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as TokenInfo,refresh: null == refresh ? _self.refresh : refresh // ignore: cast_nullable_to_non_nullable
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
}/// Create a copy of TokenBundle
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TokenInfoCopyWith<$Res> get refresh {
  
  return $TokenInfoCopyWith<$Res>(_self.refresh, (value) {
    return _then(_self.copyWith(refresh: value));
  });
}
}


/// Adds pattern-matching-related methods to [TokenBundle].
extension TokenBundlePatterns on TokenBundle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenBundle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenBundle() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenBundle value)  $default,){
final _that = this;
switch (_that) {
case _TokenBundle():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenBundle value)?  $default,){
final _that = this;
switch (_that) {
case _TokenBundle() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TokenInfo access,  TokenInfo refresh)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenBundle() when $default != null:
return $default(_that.access,_that.refresh);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TokenInfo access,  TokenInfo refresh)  $default,) {final _that = this;
switch (_that) {
case _TokenBundle():
return $default(_that.access,_that.refresh);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TokenInfo access,  TokenInfo refresh)?  $default,) {final _that = this;
switch (_that) {
case _TokenBundle() when $default != null:
return $default(_that.access,_that.refresh);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenBundle implements TokenBundle {
   _TokenBundle({required this.access, required this.refresh});
  factory _TokenBundle.fromJson(Map<String, dynamic> json) => _$TokenBundleFromJson(json);

@override final  TokenInfo access;
@override final  TokenInfo refresh;

/// Create a copy of TokenBundle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenBundleCopyWith<_TokenBundle> get copyWith => __$TokenBundleCopyWithImpl<_TokenBundle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenBundleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenBundle&&(identical(other.access, access) || other.access == access)&&(identical(other.refresh, refresh) || other.refresh == refresh));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,access,refresh);

@override
String toString() {
  return 'TokenBundle(access: $access, refresh: $refresh)';
}


}

/// @nodoc
abstract mixin class _$TokenBundleCopyWith<$Res> implements $TokenBundleCopyWith<$Res> {
  factory _$TokenBundleCopyWith(_TokenBundle value, $Res Function(_TokenBundle) _then) = __$TokenBundleCopyWithImpl;
@override @useResult
$Res call({
 TokenInfo access, TokenInfo refresh
});


@override $TokenInfoCopyWith<$Res> get access;@override $TokenInfoCopyWith<$Res> get refresh;

}
/// @nodoc
class __$TokenBundleCopyWithImpl<$Res>
    implements _$TokenBundleCopyWith<$Res> {
  __$TokenBundleCopyWithImpl(this._self, this._then);

  final _TokenBundle _self;
  final $Res Function(_TokenBundle) _then;

/// Create a copy of TokenBundle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? access = null,Object? refresh = null,}) {
  return _then(_TokenBundle(
access: null == access ? _self.access : access // ignore: cast_nullable_to_non_nullable
as TokenInfo,refresh: null == refresh ? _self.refresh : refresh // ignore: cast_nullable_to_non_nullable
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
}/// Create a copy of TokenBundle
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
