// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post_update.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestPostUpdate {
  String get id;
  String get title;
  String get description;
  String? get boardImage;

  /// Create a copy of TestPostUpdate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestPostUpdateCopyWith<TestPostUpdate> get copyWith =>
      _$TestPostUpdateCopyWithImpl<TestPostUpdate>(
          this as TestPostUpdate, _$identity);

  /// Serializes this TestPostUpdate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestPostUpdate &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.boardImage, boardImage) ||
                other.boardImage == boardImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, boardImage);

  @override
  String toString() {
    return 'TestPostUpdate(id: $id, title: $title, description: $description, boardImage: $boardImage)';
  }
}

/// @nodoc
abstract mixin class $TestPostUpdateCopyWith<$Res> {
  factory $TestPostUpdateCopyWith(
          TestPostUpdate value, $Res Function(TestPostUpdate) _then) =
      _$TestPostUpdateCopyWithImpl;
  @useResult
  $Res call({String id, String title, String description, String? boardImage});
}

/// @nodoc
class _$TestPostUpdateCopyWithImpl<$Res>
    implements $TestPostUpdateCopyWith<$Res> {
  _$TestPostUpdateCopyWithImpl(this._self, this._then);

  final TestPostUpdate _self;
  final $Res Function(TestPostUpdate) _then;

  /// Create a copy of TestPostUpdate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? boardImage = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      boardImage: freezed == boardImage
          ? _self.boardImage
          : boardImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TestPostUpdate].
extension TestPostUpdatePatterns on TestPostUpdate {
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
    TResult Function(_TestPostUpdate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate() when $default != null:
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
    TResult Function(_TestPostUpdate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate():
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
    TResult? Function(_TestPostUpdate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate() when $default != null:
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
    TResult Function(
            String id, String title, String description, String? boardImage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate() when $default != null:
        return $default(
            _that.id, _that.title, _that.description, _that.boardImage);
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
    TResult Function(
            String id, String title, String description, String? boardImage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate():
        return $default(
            _that.id, _that.title, _that.description, _that.boardImage);
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
    TResult? Function(
            String id, String title, String description, String? boardImage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostUpdate() when $default != null:
        return $default(
            _that.id, _that.title, _that.description, _that.boardImage);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TestPostUpdate implements TestPostUpdate {
  _TestPostUpdate(
      {required this.id,
      required this.title,
      required this.description,
      this.boardImage});
  factory _TestPostUpdate.fromJson(Map<String, dynamic> json) =>
      _$TestPostUpdateFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? boardImage;

  /// Create a copy of TestPostUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestPostUpdateCopyWith<_TestPostUpdate> get copyWith =>
      __$TestPostUpdateCopyWithImpl<_TestPostUpdate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestPostUpdateToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestPostUpdate &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.boardImage, boardImage) ||
                other.boardImage == boardImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, description, boardImage);

  @override
  String toString() {
    return 'TestPostUpdate(id: $id, title: $title, description: $description, boardImage: $boardImage)';
  }
}

/// @nodoc
abstract mixin class _$TestPostUpdateCopyWith<$Res>
    implements $TestPostUpdateCopyWith<$Res> {
  factory _$TestPostUpdateCopyWith(
          _TestPostUpdate value, $Res Function(_TestPostUpdate) _then) =
      __$TestPostUpdateCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, String description, String? boardImage});
}

/// @nodoc
class __$TestPostUpdateCopyWithImpl<$Res>
    implements _$TestPostUpdateCopyWith<$Res> {
  __$TestPostUpdateCopyWithImpl(this._self, this._then);

  final _TestPostUpdate _self;
  final $Res Function(_TestPostUpdate) _then;

  /// Create a copy of TestPostUpdate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? boardImage = freezed,
  }) {
    return _then(_TestPostUpdate(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      boardImage: freezed == boardImage
          ? _self.boardImage
          : boardImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
