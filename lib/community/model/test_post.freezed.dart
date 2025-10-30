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
  String get userId;
  String get nickname;
  String get description;
  @JsonKey(unknownEnumValue: TestPlatform.unknown)
  TestPlatform get platform;
  @JsonKey(unknownEnumValue: TestType.unknown)
  TestType get type;
  int get views;
  String? get thumbnailUrl;
  String get linkUrl;
  @JsonKey(name: 'startDate')
  DateTime get startDate;
  @JsonKey(name: 'endDate')
  DateTime get endDate;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  String get recruitStatus;

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
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recruitStatus, recruitStatus) ||
                other.recruitStatus == recruitStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      userId,
      nickname,
      description,
      platform,
      type,
      views,
      thumbnailUrl,
      linkUrl,
      startDate,
      endDate,
      createdAt,
      recruitStatus);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, userId: $userId, nickname: $nickname, description: $description, platform: $platform, type: $type, views: $views, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, recruitStatus: $recruitStatus)';
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
      String userId,
      String nickname,
      String description,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) TestPlatform platform,
      @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
      int views,
      String? thumbnailUrl,
      String linkUrl,
      @JsonKey(name: 'startDate') DateTime startDate,
      @JsonKey(name: 'endDate') DateTime endDate,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      String recruitStatus});
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
    Object? userId = null,
    Object? nickname = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? views = null,
    Object? thumbnailUrl = freezed,
    Object? linkUrl = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? recruitStatus = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
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
      views: null == views
          ? _self.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: null == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
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
      recruitStatus: null == recruitStatus
          ? _self.recruitStatus
          : recruitStatus // ignore: cast_nullable_to_non_nullable
              as String,
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
            String userId,
            String nickname,
            String description,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            String? thumbnailUrl,
            String linkUrl,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createdAt') DateTime createdAt,
            String recruitStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.userId,
            _that.nickname,
            _that.description,
            _that.platform,
            _that.type,
            _that.views,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt,
            _that.recruitStatus);
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
            String userId,
            String nickname,
            String description,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            String? thumbnailUrl,
            String linkUrl,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createdAt') DateTime createdAt,
            String recruitStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost():
        return $default(
            _that.id,
            _that.title,
            _that.userId,
            _that.nickname,
            _that.description,
            _that.platform,
            _that.type,
            _that.views,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt,
            _that.recruitStatus);
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
            String userId,
            String nickname,
            String description,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            String? thumbnailUrl,
            String linkUrl,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createdAt') DateTime createdAt,
            String recruitStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPost() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.userId,
            _that.nickname,
            _that.description,
            _that.platform,
            _that.type,
            _that.views,
            _that.thumbnailUrl,
            _that.linkUrl,
            _that.startDate,
            _that.endDate,
            _that.createdAt,
            _that.recruitStatus);
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
      required this.userId,
      required this.nickname,
      required this.description,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) required this.platform,
      @JsonKey(unknownEnumValue: TestType.unknown) required this.type,
      required this.views,
      this.thumbnailUrl,
      required this.linkUrl,
      @JsonKey(name: 'startDate') required this.startDate,
      @JsonKey(name: 'endDate') required this.endDate,
      @JsonKey(name: 'createdAt') required this.createdAt,
      required this.recruitStatus});
  factory _TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String userId;
  @override
  final String nickname;
  @override
  final String description;
  @override
  @JsonKey(unknownEnumValue: TestPlatform.unknown)
  final TestPlatform platform;
  @override
  @JsonKey(unknownEnumValue: TestType.unknown)
  final TestType type;
  @override
  final int views;
  @override
  final String? thumbnailUrl;
  @override
  final String linkUrl;
  @override
  @JsonKey(name: 'startDate')
  final DateTime startDate;
  @override
  @JsonKey(name: 'endDate')
  final DateTime endDate;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  final String recruitStatus;

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
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.recruitStatus, recruitStatus) ||
                other.recruitStatus == recruitStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      userId,
      nickname,
      description,
      platform,
      type,
      views,
      thumbnailUrl,
      linkUrl,
      startDate,
      endDate,
      createdAt,
      recruitStatus);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, userId: $userId, nickname: $nickname, description: $description, platform: $platform, type: $type, views: $views, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, recruitStatus: $recruitStatus)';
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
      String userId,
      String nickname,
      String description,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) TestPlatform platform,
      @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
      int views,
      String? thumbnailUrl,
      String linkUrl,
      @JsonKey(name: 'startDate') DateTime startDate,
      @JsonKey(name: 'endDate') DateTime endDate,
      @JsonKey(name: 'createdAt') DateTime createdAt,
      String recruitStatus});
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
    Object? userId = null,
    Object? nickname = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? views = null,
    Object? thumbnailUrl = freezed,
    Object? linkUrl = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
    Object? recruitStatus = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
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
      views: null == views
          ? _self.views
          : views // ignore: cast_nullable_to_non_nullable
              as int,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      linkUrl: null == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
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
      recruitStatus: null == recruitStatus
          ? _self.recruitStatus
          : recruitStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
