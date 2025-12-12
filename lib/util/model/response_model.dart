import 'package:freezed_annotation/freezed_annotation.dart';

part 'response_model.freezed.dart';
part 'response_model.g.dart';

@freezed
@JsonSerializable(genericArgumentFactories: true)
class ResponseModel<T> with _$ResponseModel<T> {
  @override
  String message;
  @override
  String code;
  @override
  T? data;

  ResponseModel({
    required this.message,
    required this.code,
    required this.data,
  });

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ResponseModelFromJson(json, fromJsonT);
}
