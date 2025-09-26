// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
TestPostCreate _$TestPostCreateFromJson(Map<String, dynamic> json) {
  return _TestPostRequest.fromJson(json);
}

/// @nodoc
mixin _$TestPostCreate {
  String get title;
  String get description;
  TestPlatform get platform;
  TestType get type;
  String get linkUrl;
  String? get boardImage;
  String get startDate;
  String get endDate;
  String get recruitStatus;

  /// Create a copy of TestPostCreate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestPostCreateCopyWith<TestPostCreate> get copyWith =>
      _$TestPostCreateCopyWithImpl<TestPostCreate>(
          this as TestPostCreate, _$identity);

  /// Serializes this TestPostCreate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestPostCreate &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.boardImage, boardImage) ||
                other.boardImage == boardImage) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.recruitStatus, recruitStatus) ||
                other.recruitStatus == recruitStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, platform,
      type, linkUrl, boardImage, startDate, endDate, recruitStatus);

  @override
  String toString() {
    return 'TestPostCreate(title: $title, description: $description, platform: $platform, type: $type, linkUrl: $linkUrl, boardImage: $boardImage, startDate: $startDate, endDate: $endDate, recruitStatus: $recruitStatus)';
  }
}

/// @nodoc
abstract mixin class $TestPostCreateCopyWith<$Res> {
  factory $TestPostCreateCopyWith(
          TestPostCreate value, $Res Function(TestPostCreate) _then) =
      _$TestPostCreateCopyWithImpl;
  @useResult
  $Res call(
      {String title,
      String description,
      TestPlatform platform,
      TestType type,
      String linkUrl,
      String? boardImage,
      String startDate,
      String endDate,
      String recruitStatus});
}

/// @nodoc
class _$TestPostCreateCopyWithImpl<$Res>
    implements $TestPostCreateCopyWith<$Res> {
  _$TestPostCreateCopyWithImpl(this._self, this._then);

  final TestPostCreate _self;
  final $Res Function(TestPostCreate) _then;

  /// Create a copy of TestPostCreate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? linkUrl = null,
    Object? boardImage = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? recruitStatus = null,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
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
      linkUrl: null == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      boardImage: freezed == boardImage
          ? _self.boardImage
          : boardImage // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      recruitStatus: null == recruitStatus
          ? _self.recruitStatus
          : recruitStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [TestPostCreate].
extension TestPostCreatePatterns on TestPostCreate {
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
    TResult Function(_TestPostRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest() when $default != null:
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
    TResult Function(_TestPostRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest():
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
    TResult? Function(_TestPostRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest() when $default != null:
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
            String title,
            String description,
            TestPlatform platform,
            TestType type,
            String linkUrl,
            String? boardImage,
            String startDate,
            String endDate,
            String recruitStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest() when $default != null:
        return $default(
            _that.title,
            _that.description,
            _that.platform,
            _that.type,
            _that.linkUrl,
            _that.boardImage,
            _that.startDate,
            _that.endDate,
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
            String title,
            String description,
            TestPlatform platform,
            TestType type,
            String linkUrl,
            String? boardImage,
            String startDate,
            String endDate,
            String recruitStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest():
        return $default(
            _that.title,
            _that.description,
            _that.platform,
            _that.type,
            _that.linkUrl,
            _that.boardImage,
            _that.startDate,
            _that.endDate,
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
            String title,
            String description,
            TestPlatform platform,
            TestType type,
            String linkUrl,
            String? boardImage,
            String startDate,
            String endDate,
            String recruitStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TestPostRequest() when $default != null:
        return $default(
            _that.title,
            _that.description,
            _that.platform,
            _that.type,
            _that.linkUrl,
            _that.boardImage,
            _that.startDate,
            _that.endDate,
            _that.recruitStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TestPostRequest implements TestPostCreate {
  _TestPostRequest(
      {required this.title,
      required this.description,
      required this.platform,
      required this.type,
      required this.linkUrl,
      this.boardImage,
      required this.startDate,
      required this.endDate,
      required this.recruitStatus});
  factory _TestPostRequest.fromJson(Map<String, dynamic> json) =>
      _$TestPostRequestFromJson(json);

  @override
  final String title;
  @override
  final String description;
  @override
  final TestPlatform platform;
  @override
  final TestType type;
  @override
  final String linkUrl;
  @override
  final String? boardImage;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final String recruitStatus;

  /// Create a copy of TestPostCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TestPostRequestCopyWith<_TestPostRequest> get copyWith =>
      __$TestPostRequestCopyWithImpl<_TestPostRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TestPostRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestPostRequest &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.linkUrl, linkUrl) || other.linkUrl == linkUrl) &&
            (identical(other.boardImage, boardImage) ||
                other.boardImage == boardImage) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.recruitStatus, recruitStatus) ||
                other.recruitStatus == recruitStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, platform,
      type, linkUrl, boardImage, startDate, endDate, recruitStatus);

  @override
  String toString() {
    return 'TestPostCreate(title: $title, description: $description, platform: $platform, type: $type, linkUrl: $linkUrl, boardImage: $boardImage, startDate: $startDate, endDate: $endDate, recruitStatus: $recruitStatus)';
  }
}

/// @nodoc
abstract mixin class _$TestPostRequestCopyWith<$Res>
    implements $TestPostCreateCopyWith<$Res> {
  factory _$TestPostRequestCopyWith(
          _TestPostRequest value, $Res Function(_TestPostRequest) _then) =
      __$TestPostRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      TestPlatform platform,
      TestType type,
      String linkUrl,
      String? boardImage,
      String startDate,
      String endDate,
      String recruitStatus});
}

/// @nodoc
class __$TestPostRequestCopyWithImpl<$Res>
    implements _$TestPostRequestCopyWith<$Res> {
  __$TestPostRequestCopyWithImpl(this._self, this._then);

  final _TestPostRequest _self;
  final $Res Function(_TestPostRequest) _then;

  /// Create a copy of TestPostCreate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? linkUrl = null,
    Object? boardImage = freezed,
    Object? startDate = null,
    Object? endDate = null,
    Object? recruitStatus = null,
  }) {
    return _then(_TestPostRequest(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
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
      linkUrl: null == linkUrl
          ? _self.linkUrl
          : linkUrl // ignore: cast_nullable_to_non_nullable
              as String,
      boardImage: freezed == boardImage
          ? _self.boardImage
          : boardImage // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String,
      endDate: null == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as String,
      recruitStatus: null == recruitStatus
          ? _self.recruitStatus
          : recruitStatus // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
