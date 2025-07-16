import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/user/model/token_info.dart';
import 'package:test_quest/user/provider/auth_provider.dart';
import 'package:test_quest/util/service/storage_service.dart';

class DefaultInterceptor extends Interceptor {
  final Ref ref;
  Completer<AccessResponse>? _refreshCompleter;
  bool _isRefreshing = false;

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
    log('[onRequest] ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    log('[DioInterceptor onError] ${err.response?.statusCode} - ${err.requestOptions.path}');

    // 401 에러 처리 (토큰 만료)
    if (err.response?.statusCode == 401) {
      log('[401] 토큰 만료, 갱신 시도');

      // 이미 refresh 중인 경우 대기
      if (_isRefreshing && _refreshCompleter != null) {
        log('[401] 이미 갱신 중, 대기');
        try {
          final refreshResult = await _refreshCompleter!.future;
          await _retryRequest(err, refreshResult, handler);
          return;
        } catch (e) {
          log('[401] 갱신 대기 중 실패: $e');
          _resetRefreshState();
          _handleAuthError(handler, err);
          return;
        }
      }

      // 첫 번째 401 에러인 경우에만 refresh 시도
      if (err.requestOptions.extra['retry'] != true) {
        log('[401] 첫 번째 401 에러, 토큰 갱신 시작');
        err.requestOptions.extra['retry'] = true;

        _isRefreshing = true;
        _refreshCompleter = Completer<AccessResponse>();

        try {
          // 인터셉터 내부에서 직접 토큰 갱신
          final refreshResult = await _refreshToken();
          log('[401] 토큰 갱신 성공');
          _refreshCompleter!.complete(refreshResult);
          await _retryRequest(err, refreshResult, handler);
          // 성공 후 상태 초기화
          _resetRefreshState();
        } catch (e) {
          log('[401] 토큰 갱신 실패: $e');
          _refreshCompleter?.completeError(e);
          _resetRefreshState();
          _handleAuthError(handler, err);
        }
        return;
      } else {
        log('[401] 재시도 후에도 401, 로그아웃 처리');
        _handleAuthError(handler, err);
        return;
      }
    }

    // 403 에러 처리 (권한 없음)
    if (err.response?.statusCode == 403) {
      log('[403 Forbidden] 권한이 없습니다. 로그아웃 후 로그인 화면으로 이동');
      _handleAuthError(handler, err);
      return;
    }

    // 다른 에러들에 대한 처리
    _handleOtherErrors(err, handler);
  }

  /// 토큰 갱신 로직을 인터셉터 내부에 구현
  Future<AccessResponse> _refreshToken() async {
    log('[refresh] 토큰 갱신 시작');
    final storage = ref.read(storageProvider);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      log('[refresh] 리프레시 토큰이 없음');
      throw Exception('리프레시 토큰이 없습니다.');
    }

    log('[refresh] 리프레시 토큰으로 갱신 요청');

    // 순환 의존성 방지를 위해 새로운 Dio 인스턴스 생성
    final refreshDio = Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    try {
      final response = await refreshDio.post(
        '/auth/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      log('[refresh] 응답 받음: ${response.statusCode}');
      final data = response.data;

      if (data['code'] != "200" || data['data'] == null) {
        log('[refresh] 응답 에러: ${data['message']}');
        throw Exception(data['message'] ?? '토큰 갱신에 실패했습니다.');
      }

      final accessResponse = AccessResponse.fromJson(data['data']);

      // 새 토큰 저장
      await storage.write(
          key: ACCESS_TOKEN_KEY, value: accessResponse.access.token);

      log('[refresh] 토큰 갱신 성공: ${accessResponse.access.token.substring(0, 20)}...');
      return accessResponse;
    } catch (e) {
      log('[refresh] DioException: $e');
      rethrow;
    }
  }

  Future<void> _retryRequest(DioException err, AccessResponse refreshResult,
      ErrorInterceptorHandler handler) async {
    try {
      log('[retry] 요청 재시도: ${err.requestOptions.path}');
      log('[retry] 사용할 토큰: ${refreshResult.access.token.substring(0, 20)}...');

      // 새로운 RequestOptions 생성 (기존 옵션 복사)
      final requestOptions = RequestOptions(
        path: err.requestOptions.path,
        method: err.requestOptions.method,
        baseUrl: err.requestOptions.baseUrl,
        queryParameters: err.requestOptions.queryParameters,
        data: err.requestOptions.data,
        headers: {
          ...err.requestOptions.headers,
          'Authorization': 'Bearer ${refreshResult.access.token}',
        },
        extra: err.requestOptions.extra,
        responseType: err.requestOptions.responseType,
        contentType: err.requestOptions.contentType,
      );

      // 새로운 Dio 인스턴스로 재시도
      final retryDio = Dio(BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? '',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      final response = await retryDio.fetch(requestOptions);
      log('[retry] 재시도 성공: ${response.statusCode}');
      handler.resolve(response);
    } catch (e) {
      log('[retry] 재시도 실패: $e');
      // 재시도 실패 시 원본 에러가 아닌 새로운 에러를 반환
      if (e is DioException) {
        handler.reject(e);
      } else {
        handler.reject(err);
      }
    }
  }

  /// 토큰 갱신 상태 초기화
  void _resetRefreshState() {
    _isRefreshing = false;
    _refreshCompleter = null;
    log('[refresh] 상태 초기화 완료');
  }

  void _handleAuthError(ErrorInterceptorHandler handler, DioException err) {
    log('[auth error] 인증 에러 발생, 로그아웃 처리');
    _resetRefreshState(); // 에러 시에도 상태 초기화

    // Auth Provider를 통해 로그아웃 (자동으로 로그인 화면 이동)
    Future.microtask(() async {
      await ref.read(authProvider.notifier).logout();
      log('[auth error] 로그아웃 완료, Router Provider가 리다이렉션 처리');
    });

    handler.reject(err);
  }

  void _handleOtherErrors(DioException err, ErrorInterceptorHandler handler) {
    // 네트워크 에러, 타임아웃 등에 대한 처리
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      log('[network timeout] ${err.requestOptions.path}');
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('[DIO RESPONSE] ${response.statusCode} - ${response.requestOptions.path}');
    handler.next(response);
  }
}
