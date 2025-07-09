// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestPost {
  String get id;
  String get title;
  String get auth;
  String get description;
  TestPlatform get platform;
  TestType get type;
  String? get thumbnailUrl;
  String? get linkUrl;
  DateTime get startDate;
  DateTime get endDate;
  DateTime get createdAt;

  /// Create a copy of TestPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestPostCopyWith<TestPost> get copyWith =>
      _$TestPostCopyWithImpl<TestPost>(this as TestPost, _$identity);

  /// Serializes this TestPost to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestPost &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, auth, description,
      platform, type, thumbnailUrl, linkUrl, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, auth: $auth, description: $description, platform: $platform, type: $type, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $TestPostCopyWith<$Res> {
  factory $TestPostCopyWith(TestPost value, $Res Function(TestPost) _then) =
      _$TestPostCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String auth,
      String description,
      TestPlatform platform,
      TestType type,
      String? thumbnailUrl,
      String? linkUrl,
      DateTime startDate,
      DateTime endDate,
      DateTime createdAt});
}

/// @nodoc
class _$TestPostCopyWithImpl<$Res> implements $TestPostCopyWith<$Res> {
  _$TestPostCopyWithImpl(this._self, this._then);

  final TestPost _self;
  final $Res Function(TestPost) _then;

  /// Create a copy of TestPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? auth = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? thumbnailUrl = freezed,
    Object? linkUrl = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
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
      auth: null == auth
          ? _self.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TestPlatform,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TestType,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: freezed == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [TestPost].
extension TestPostPatterns on TestPost {
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
    TResult Function(_TestPost value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
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
    TResult Function(_TestPost value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost():
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
    TResult? Function(_TestPost value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
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
            String id,
            String title,
            String auth,
            String description,
            TestPlatform platform,
            TestType type,
            String? thumbnailUrl,
            String? linkUrl,
            DateTime startDate,
            DateTime endDate,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.auth,
            _that.description,
            _that.platform,
            _that.type,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt);
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
            String id,
            String title,
            String auth,
            String description,
            TestPlatform platform,
            TestType type,
            String? thumbnailUrl,
            String? linkUrl,
            DateTime startDate,
            DateTime endDate,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost():
        return $default(
            _that.id,
            _that.title,
            _that.auth,
            _that.description,
            _that.platform,
            _that.type,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt);
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
            String id,
            String title,
            String auth,
            String description,
            TestPlatform platform,
            TestType type,
            String? thumbnailUrl,
            String? linkUrl,
            DateTime startDate,
            DateTime endDate,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.auth,
            _that.description,
            _that.platform,
            _that.type,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TestPost implements TestPost {
  _TestPost(
      {required this.id,
      required this.title,
      required this.auth,
      required this.description,
      required this.platform,
      required this.type,
      this.thumbnailUrl,
      this.linkUrl,
      required this.startDate,
      required this.endDate,
      required this.createdAt});
  factory _TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String auth;
  @override
  final String description;
  @override
  final TestPlatform platform;
  @override
  final TestType type;
  @override
  final String? thumbnailUrl;
  @override
  final String? linkUrl;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final DateTime createdAt;

  /// Create a copy of TestPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestPostCopyWith<_TestPost> get copyWith =>
      __$TestPostCopyWithImpl<_TestPost>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestPostToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestPost &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.auth, auth) || other.auth == auth) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, auth, description,
      platform, type, thumbnailUrl, linkUrl, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, auth: $auth, description: $description, platform: $platform, type: $type, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$TestPostCopyWith<$Res>
    implements $TestPostCopyWith<$Res> {
  factory _$TestPostCopyWith(_TestPost value, $Res Function(_TestPost) _then) =
      __$TestPostCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String auth,
      String description,
      TestPlatform platform,
      TestType type,
      String? thumbnailUrl,
      String? linkUrl,
      DateTime startDate,
      DateTime endDate,
      DateTime createdAt});
}

/// @nodoc
class __$TestPostCopyWithImpl<$Res> implements _$TestPostCopyWith<$Res> {
  __$TestPostCopyWithImpl(this._self, this._then);

  final _TestPost _self;
  final $Res Function(_TestPost) _then;

  /// Create a copy of TestPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? auth = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? thumbnailUrl = freezed,
    Object? linkUrl = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_TestPost(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      auth: null == auth
          ? _self.auth
          : auth // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as TestPlatform,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TestType,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: freezed == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
