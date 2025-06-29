// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
  String get description;
  TestPlatform get platform;
  TestType get type;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @JsonKey(name: 'link_url')
  String? get linkUrl;
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @JsonKey(name: 'end_date')
  DateTime get endDate;
  @JsonKey(name: 'created_at')
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
  int get hashCode => Object.hash(runtimeType, id, title, description, platform,
      type, thumbnailUrl, linkUrl, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, description: $description, platform: $platform, type: $type, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
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
      String description,
      TestPlatform platform,
      TestType type,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'link_url') String? linkUrl,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
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

/// @nodoc
@JsonSerializable()
class _TestPost implements TestPost {
  _TestPost(
      {required this.id,
      required this.title,
      required this.description,
      required this.platform,
      required this.type,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'link_url') this.linkUrl,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') required this.endDate,
      @JsonKey(name: 'created_at') required this.createdAt});
  factory _TestPost.fromJson(Map<String, dynamic> json) =>
      _$TestPostFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final TestPlatform platform;
  @override
  final TestType type;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'link_url')
  final String? linkUrl;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime endDate;
  @override
  @JsonKey(name: 'created_at')
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
  int get hashCode => Object.hash(runtimeType, id, title, description, platform,
      type, thumbnailUrl, linkUrl, startDate, endDate, createdAt);

  @override
  String toString() {
    return 'TestPost(id: $id, title: $title, description: $description, platform: $platform, type: $type, thumbnailUrl: $thumbnailUrl, linkUrl: $linkUrl, startDate: $startDate, endDate: $endDate, createdAt: $createdAt)';
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
      String description,
      TestPlatform platform,
      TestType type,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'link_url') String? linkUrl,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime endDate,
      @JsonKey(name: 'created_at') DateTime createdAt});
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
