import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/user/model/signup_form.dart';
import 'package:test_quest/user/model/token_bundle.dart';
import 'package:test_quest/user/repository/auth_repository.dart';
import 'package:test_quest/util/extensions/signup_form_extension.dart';
import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/provider/dio_provider.dart';
import 'package:test_quest/util/result.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepositoryImpl(dio);
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Result<void>> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> getMyInfo() {
    // TODO: implement getMyInfo
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel<TokenBundle>> login(
      {required String email, required String password}) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      log('로그인 응답: ${response.data}');

      if (response.data == null) {
        throw Exception('로그인 응답이 비어 있습니다.');
      }

      final responseData = ResponseModel<TokenBundle>.fromJson(response.data,
          (json) => TokenBundle.fromJson(json as Map<String, dynamic>));

      return responseData;
    } on DioException catch (e) {
      log('[auth_repository_impl.dart] 로그인 실패: ${e.response?.data}');
      log('[auth_repository_impl.dart] 로그인 실패: ${e.stackTrace}');
      throw Exception(e.response?.data['message'] ?? '로그인에 실패했습니다.');
    }
  }

  @override
  Future<Result<void>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<ResponseModel<void>> signup({required SignupForm data}) async {
    try {
      _dio.options.headers['Content-Type'] = 'multipart/form-data';
      final formData = await data.toFormData();
      log(formData.toString());
      final response = await _dio.post('/auth/register', data: formData);
      final responseData = ResponseModel<void>.fromJson(
        response.data,
        (_) {},
      );

      return responseData;
    } on DioException catch (e) {
      log('[auth_repository] 회원가입 실패 ${e.toString()}');
      throw (e.response?.data['message'] ?? '회원가입에 실패했습니다.');
    }
  }
}
