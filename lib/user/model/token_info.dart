import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info.freezed.dart';
part 'token_info.g.dart';

@freezed
abstract class TokenInfo with _$TokenInfo {
  factory TokenInfo({
    required String token,
    required int expiresIn,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);
}
