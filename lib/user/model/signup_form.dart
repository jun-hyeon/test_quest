import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_form.freezed.dart';
part 'signup_form.g.dart';

@freezed
abstract class SignupForm with _$SignupForm {
  factory SignupForm({
    required String email,
    required String password,
    required String nickname,
    required String name,
    String? profileImg,
  }) = _SignupForm;

  factory SignupForm.fromJson(Map<String, dynamic> json) =>
      _$SignupFormFromJson(json);
}
