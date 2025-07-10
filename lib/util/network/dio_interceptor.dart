import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/user/repository/auth_repository_impl.dart';
import 'package:test_quest/util/network/provider/dio_provider.dart';
import 'package:test_quest/util/service/storage_service.dart';

class DefaultInterceptor extends Interceptor {
  final Ref ref;

  DefaultInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authRequired = options.extra['authRequired'] ?? true;

    if (authRequired) {
      final storage = ref.read(storageProvider);
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final authRepository = ref.read(authRepositoryProvider);

      try {
        final refreshResult = await authRepository.refresh();

        final storage = ref.read(storageProvider);
        final accessToken = refreshResult.access.token;
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final requestOptions = err.requestOptions;
        requestOptions.headers['Authorization'] = 'Bearer $accessToken';

        final dio = ref.read(dioProvider);
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response); // Retry original request
      } catch (_) {
        return handler.next(err); // Pass the error to the next handler
      }
    }

    handler.next(err); // Pass all other errors through
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('[DIO RESPONSE]');
    log('Status Code: ${response.statusCode}');
    log('Data: ${response.data}');
    handler.next(response);
  }
}
