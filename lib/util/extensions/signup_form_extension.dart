import 'package:dio/dio.dart';
import 'package:test_quest/user/model/signup_form.dart';

extension SignupFormExtension on SignupForm {
  Future<FormData> toFormData() async {
    final Map<String, dynamic> formDataMap = {
      'email': email,
      'password': password,
      'nickname': nickname,
      'name': name,
    };

    if (profileImage != null && profileImage!.isNotEmpty) {
      formDataMap['profileImage'] = await MultipartFile.fromFile(
        profileImage!,
        filename: profileImage!.split('/').last,
      );
    }
    return FormData.fromMap(formDataMap);
  }
}
