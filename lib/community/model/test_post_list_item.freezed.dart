// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post_list_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestPostListItem {
  String get id;
  String get title;
  String get nickname;
  String get thumbnailUrl;
  @JsonKey(unknownEnumValue: TestPlatform.unknown)
  TestPlatform get platform;
  @JsonKey(unknownEnumValue: TestType.unknown)
  TestType get type;
  int get views;
  @JsonKey(name: 'startDate')
  DateTime get startDate;
  @JsonKey(name: 'endDate')
  DateTime get endDate;
  @JsonKey(name: 'createAt')
  DateTime get createdAt;

  /// Create a copy of TestPostListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestPostListItemCopyWith<TestPostListItem> get copyWith =>
      _$TestPostListItemCopyWithImpl<TestPostListItem>(
          this as TestPostListItem, _$identity);

  /// Serializes this TestPostListItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestPostListItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, nickname,
      thumbnailUrl, platform, type, views, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPostListItem(id: $id, title: $title, nickname: $nickname, thumbnailUrl: $thumbnailUrl, platform: $platform, type: $type, views: $views, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $TestPostListItemCopyWith<$Res> {
  factory $TestPostListItemCopyWith(
          TestPostListItem value, $Res Function(TestPostListItem) _then) =
      _$TestPostListItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String nickname,
      String thumbnailUrl,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) TestPlatform platform,
      @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
      int views,
      @JsonKey(name: 'startDate') DateTime startDate,
      @JsonKey(name: 'endDate') DateTime endDate,
      @JsonKey(name: 'createAt') DateTime createdAt});
}

/// @nodoc
class _$TestPostListItemCopyWithImpl<$Res>
    implements $TestPostListItemCopyWith<$Res> {
  _$TestPostListItemCopyWithImpl(this._self, this._then);

  final TestPostListItem _self;
  final $Res Function(TestPostListItem) _then;

  /// Create a copy of TestPostListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? nickname = null,
    Object? thumbnailUrl = null,
    Object? platform = null,
    Object? type = null,
    Object? views = null,
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
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [TestPostListItem].
extension TestPostListItemPatterns on TestPostListItem {
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
    TResult Function(_TestPostListItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem() when $default != null:
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
    TResult Function(_TestPostListItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem():
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
    TResult? Function(_TestPostListItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem() when $default != null:
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
            String nickname,
            String thumbnailUrl,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createAt') DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.nickname,
            _that.thumbnailUrl,
            _that.platform,
            _that.type,
            _that.views,
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
            String nickname,
            String thumbnailUrl,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createAt') DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem():
        return $default(
            _that.id,
            _that.title,
            _that.nickname,
            _that.thumbnailUrl,
            _that.platform,
            _that.type,
            _that.views,
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
            String nickname,
            String thumbnailUrl,
            @JsonKey(unknownEnumValue: TestPlatform.unknown)
            TestPlatform platform,
            @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
            int views,
            @JsonKey(name: 'startDate') DateTime startDate,
            @JsonKey(name: 'endDate') DateTime endDate,
            @JsonKey(name: 'createAt') DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostListItem() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.nickname,
            _that.thumbnailUrl,
            _that.platform,
            _that.type,
            _that.views,
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
class _TestPostListItem implements TestPostListItem {
  _TestPostListItem(
      {required this.id,
      required this.title,
      required this.nickname,
      required this.thumbnailUrl,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) required this.platform,
      @JsonKey(unknownEnumValue: TestType.unknown) required this.type,
      required this.views,
      @JsonKey(name: 'startDate') required this.startDate,
      @JsonKey(name: 'endDate') required this.endDate,
      @JsonKey(name: 'createAt') required this.createdAt});
  factory _TestPostListItem.fromJson(Map<String, dynamic> json) =>
      _$TestPostListItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String nickname;
  @override
  final String thumbnailUrl;
  @override
  @JsonKey(unknownEnumValue: TestPlatform.unknown)
  final TestPlatform platform;
  @override
  @JsonKey(unknownEnumValue: TestType.unknown)
  final TestType type;
  @override
  final int views;
  @override
  @JsonKey(name: 'startDate')
  final DateTime startDate;
  @override
  @JsonKey(name: 'endDate')
  final DateTime endDate;
  @override
  @JsonKey(name: 'createAt')
  final DateTime createdAt;

  /// Create a copy of TestPostListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestPostListItemCopyWith<_TestPostListItem> get copyWith =>
      __$TestPostListItemCopyWithImpl<_TestPostListItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestPostListItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestPostListItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, nickname,
      thumbnailUrl, platform, type, views, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPostListItem(id: $id, title: $title, nickname: $nickname, thumbnailUrl: $thumbnailUrl, platform: $platform, type: $type, views: $views, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$TestPostListItemCopyWith<$Res>
    implements $TestPostListItemCopyWith<$Res> {
  factory _$TestPostListItemCopyWith(
          _TestPostListItem value, $Res Function(_TestPostListItem) _then) =
      __$TestPostListItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String nickname,
      String thumbnailUrl,
      @JsonKey(unknownEnumValue: TestPlatform.unknown) TestPlatform platform,
      @JsonKey(unknownEnumValue: TestType.unknown) TestType type,
      int views,
      @JsonKey(name: 'startDate') DateTime startDate,
      @JsonKey(name: 'endDate') DateTime endDate,
      @JsonKey(name: 'createAt') DateTime createdAt});
}

/// @nodoc
class __$TestPostListItemCopyWithImpl<$Res>
    implements _$TestPostListItemCopyWith<$Res> {
  __$TestPostListItemCopyWithImpl(this._self, this._then);

  final _TestPostListItem _self;
  final $Res Function(_TestPostListItem) _then;

  /// Create a copy of TestPostListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? nickname = null,
    Object? thumbnailUrl = null,
    Object? platform = null,
    Object? type = null,
    Object? views = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? createdAt = null,
  }) {
    return _then(_TestPostListItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
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
