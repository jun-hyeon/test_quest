import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/network/dio_interceptor.dart';

/// @deprecated 이 Provider는 Firebase로 마이그레이션되었습니다.
/// 더 이상 REST API 통신을 사용하지 않습니다.

/// @deprecated 이 Provider는 Firebase로 마이그레이션되었습니다.
/// 더 이상 REST API 통신을 사용하지 않습니다.
@Deprecated('Firebase로 마이그레이션되었습니다. 더 이상 REST API 통신을 사용하지 않습니다.')
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );

  // Add interceptors if needed
  dio.interceptors.add(DefaultInterceptor(ref));

  return dio;
});
