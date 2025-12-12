import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_quest/auth/model/token_info.dart';

part 'token_bundle.freezed.dart';
part 'token_bundle.g.dart';

@freezed
abstract class TokenBundle with _$TokenBundle {
  factory TokenBundle({required TokenInfo access, required TokenInfo refresh}) =
      _TokenBundle;

  factory TokenBundle.fromJson(Map<String, dynamic> json) =>
      _$TokenBundleFromJson(json);
}
