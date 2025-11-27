// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post_pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestPostPagination {

 List<TestPost> get posts; bool get hasNext;
/// Create a copy of TestPostPagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestPostPaginationCopyWith<TestPostPagination> get copyWith => _$TestPostPaginationCopyWithImpl<TestPostPagination>(this as TestPostPagination, _$identity);

  /// Serializes this TestPostPagination to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestPostPagination&&const DeepCollectionEquality().equals(other.posts, posts)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(posts),hasNext);

@override
String toString() {
  return 'TestPostPagination(posts: $posts, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class $TestPostPaginationCopyWith<$Res>  {
  factory $TestPostPaginationCopyWith(TestPostPagination value, $Res Function(TestPostPagination) _then) = _$TestPostPaginationCopyWithImpl;
@useResult
$Res call({
 List<TestPost> posts, bool hasNext
});




}
/// @nodoc
class _$TestPostPaginationCopyWithImpl<$Res>
    implements $TestPostPaginationCopyWith<$Res> {
  _$TestPostPaginationCopyWithImpl(this._self, this._then);

  final TestPostPagination _self;
  final $Res Function(TestPostPagination) _then;

/// Create a copy of TestPostPagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posts = null,Object? hasNext = null,}) {
  return _then(_self.copyWith(
posts: null == posts ? _self.posts : posts // ignore: cast_nullable_to_non_nullable
as List<TestPost>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TestPostPagination].
extension TestPostPaginationPatterns on TestPostPagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestPostPagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestPostPagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestPostPagination value)  $default,){
final _that = this;
switch (_that) {
case _TestPostPagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestPostPagination value)?  $default,){
final _that = this;
switch (_that) {
case _TestPostPagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TestPost> posts,  bool hasNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestPostPagination() when $default != null:
return $default(_that.posts,_that.hasNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TestPost> posts,  bool hasNext)  $default,) {final _that = this;
switch (_that) {
case _TestPostPagination():
return $default(_that.posts,_that.hasNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TestPost> posts,  bool hasNext)?  $default,) {final _that = this;
switch (_that) {
case _TestPostPagination() when $default != null:
return $default(_that.posts,_that.hasNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestPostPagination implements TestPostPagination {
   _TestPostPagination({required final  List<TestPost> posts, required this.hasNext}): _posts = posts;
  factory _TestPostPagination.fromJson(Map<String, dynamic> json) => _$TestPostPaginationFromJson(json);

 final  List<TestPost> _posts;
@override List<TestPost> get posts {
  if (_posts is EqualUnmodifiableListView) return _posts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_posts);
}

@override final  bool hasNext;

/// Create a copy of TestPostPagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestPostPaginationCopyWith<_TestPostPagination> get copyWith => __$TestPostPaginationCopyWithImpl<_TestPostPagination>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestPostPaginationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestPostPagination&&const DeepCollectionEquality().equals(other._posts, _posts)&&(identical(other.hasNext, hasNext) || other.hasNext == hasNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_posts),hasNext);

@override
String toString() {
  return 'TestPostPagination(posts: $posts, hasNext: $hasNext)';
}


}

/// @nodoc
abstract mixin class _$TestPostPaginationCopyWith<$Res> implements $TestPostPaginationCopyWith<$Res> {
  factory _$TestPostPaginationCopyWith(_TestPostPagination value, $Res Function(_TestPostPagination) _then) = __$TestPostPaginationCopyWithImpl;
@override @useResult
$Res call({
 List<TestPost> posts, bool hasNext
});




}
/// @nodoc
class __$TestPostPaginationCopyWithImpl<$Res>
    implements _$TestPostPaginationCopyWith<$Res> {
  __$TestPostPaginationCopyWithImpl(this._self, this._then);

  final _TestPostPagination _self;
  final $Res Function(_TestPostPagination) _then;

/// Create a copy of TestPostPagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posts = null,Object? hasNext = null,}) {
  return _then(_TestPostPagination(
posts: null == posts ? _self._posts : posts // ignore: cast_nullable_to_non_nullable
as List<TestPost>,hasNext: null == hasNext ? _self.hasNext : hasNext // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
