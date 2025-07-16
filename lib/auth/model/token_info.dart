import 'package:freezed_annotation/freezed_annotation.dart';

part '../../user/model/token_info.freezed.dart';
part '../../user/model/token_info.g.dart';

@freezed
abstract class TokenInfo with _$TokenInfo {
  factory TokenInfo({
    required String token,
    required int expiresIn,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);
}

@freezed
abstract class AccessResponse with _$AccessResponse {
  factory AccessResponse({
    required TokenInfo access,
  }) = _AccessResponse;

  factory AccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AccessResponseFromJson(json);
}
