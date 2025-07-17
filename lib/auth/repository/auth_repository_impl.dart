import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/model/signup_form.dart';
import 'package:test_quest/auth/model/token_bundle.dart';
import 'package:test_quest/auth/model/token_info.dart';
import 'package:test_quest/auth/repository/auth_repository.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/util/extensions/signup_form_extension.dart';
import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/network/provider/dio_provider.dart';
import 'package:test_quest/util/result.dart';
import 'package:test_quest/util/service/storage_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  final storage = ref.read(storageProvider);
  return AuthRepositoryImpl(dio, storage);
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final StorageService storage;

  AuthRepositoryImpl(this.dio, this.storage);

  @override
  Future<ResponseModel<void>> deleteAccount() async {
    final response = await dio.post('/user/delete');
    final responseData = ResponseModel<void>.fromJson(response.data, (_) {});
    return responseData;
  }

  @override
  Future<AccessResponse> refresh() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      throw '토큰이 만료되었습니다.';
    }

    try {
      final response = await dio.post(
        '/auth/refresh',
        options: Options(extra: {
          'authRequired': false,
        }, headers: {
          'Authorization': 'Bearer $refreshToken'
        }),
      );

      final data = ResponseModel.fromJson(response.data,
          (json) => AccessResponse.fromJson(json as Map<String, dynamic>));

      if (data.data == null) {
        throw '재발급 실패!';
      }

      final accessResponse = data.data!;

      // 🎯 새로운 Access Token을 스토리지에 저장
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: accessResponse.access.token);

      log('[auth_repository] 토큰 갱신 및 저장 완료: ${accessResponse.access.token.substring(0, 20)}...');

      return accessResponse;
    } on DioException catch (e) {
      log('[auth_repository] 토큰 갱신 실패: ${e.message}');
      throw '${e.message}';
    }
  }

  @override
  Future<TokenBundle> login(
      {required String email, required String password}) async {
    try {
      final response = await dio.post('/auth/login',
          data: {
            'email': email,
            'password': password,
          },
          options: Options(
            extra: {'authRequired': false},
          ));

      if (response.data == null) {
        throw Exception('로그인 응답이 비어 있습니다.');
      }

      final responseData = ResponseModel<TokenBundle>.fromJson(response.data,
          (json) => TokenBundle.fromJson(json as Map<String, dynamic>));
      if (responseData.data == null) {
        throw '로그인 응답이 비어있습니다.';
      }
      return responseData.data!;
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
      final formData = await data.toFormData();
      log(formData.toString());
      final response = await dio.post(
        '/auth/register',
        data: formData,
        options: Options(
          extra: {'authRequired': false},
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
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
