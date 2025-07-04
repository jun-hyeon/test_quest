// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_post_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestPostRequest {
  String get userId;
  String get author;
  String get title;
  String get description;
  TestPlatform get platform;
  TestType get type;
  String get linkUrl;
  String? get boardImage;
  String get startDate;
  String get endDate;

  /// Create a copy of TestPostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TestPostRequestCopyWith<TestPostRequest> get copyWith =>
      _$TestPostRequestCopyWithImpl<TestPostRequest>(
          this as TestPostRequest, _$identity);

  /// Serializes this TestPostRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TestPostRequest &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.author, author) || other.author == author) &&
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
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, author, title,
      description, platform, type, linkUrl, boardImage, startDate, endDate);

  @override
  String toString() {
    return 'TestPostRequest(userId: $userId, author: $author, title: $title, description: $description, platform: $platform, type: $type, linkUrl: $linkUrl, boardImage: $boardImage, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class $TestPostRequestCopyWith<$Res> {
  factory $TestPostRequestCopyWith(
          TestPostRequest value, $Res Function(TestPostRequest) _then) =
      _$TestPostRequestCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String author,
      String title,
      String description,
      TestPlatform platform,
      TestType type,
      String linkUrl,
      String? boardImage,
      String startDate,
      String endDate});
}

/// @nodoc
class _$TestPostRequestCopyWithImpl<$Res>
    implements $TestPostRequestCopyWith<$Res> {
  _$TestPostRequestCopyWithImpl(this._self, this._then);

  final TestPostRequest _self;
  final $Res Function(TestPostRequest) _then;

  /// Create a copy of TestPostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? author = null,
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? linkUrl = null,
    Object? boardImage = freezed,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TestPostRequest implements TestPostRequest {
  _TestPostRequest(
      {required this.userId,
      required this.author,
      required this.title,
      required this.description,
      required this.platform,
      required this.type,
      required this.linkUrl,
      this.boardImage,
      required this.startDate,
      required this.endDate});
  factory _TestPostRequest.fromJson(Map<String, dynamic> json) =>
      _$TestPostRequestFromJson(json);

  @override
  final String userId;
  @override
  final String author;
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

  /// Create a copy of TestPostRequest
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
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.author, author) || other.author == author) &&
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
            (identical(other.endDate, endDate) || other.endDate == endDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, author, title,
      description, platform, type, linkUrl, boardImage, startDate, endDate);

  @override
  String toString() {
    return 'TestPostRequest(userId: $userId, author: $author, title: $title, description: $description, platform: $platform, type: $type, linkUrl: $linkUrl, boardImage: $boardImage, startDate: $startDate, endDate: $endDate)';
  }
}

/// @nodoc
abstract mixin class _$TestPostRequestCopyWith<$Res>
    implements $TestPostRequestCopyWith<$Res> {
  factory _$TestPostRequestCopyWith(
          _TestPostRequest value, $Res Function(_TestPostRequest) _then) =
      __$TestPostRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String author,
      String title,
      String description,
      TestPlatform platform,
      TestType type,
      String linkUrl,
      String? boardImage,
      String startDate,
      String endDate});
}

/// @nodoc
class __$TestPostRequestCopyWithImpl<$Res>
    implements _$TestPostRequestCopyWith<$Res> {
  __$TestPostRequestCopyWithImpl(this._self, this._then);

  final _TestPostRequest _self;
  final $Res Function(_TestPostRequest) _then;

  /// Create a copy of TestPostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? author = null,
    Object? title = null,
    Object? description = null,
    Object? platform = null,
    Object? type = null,
    Object? linkUrl = null,
    Object? boardImage = freezed,
    Object? startDate = null,
    Object? endDate = null,
  }) {
    return _then(_TestPostRequest(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

// dart format on
