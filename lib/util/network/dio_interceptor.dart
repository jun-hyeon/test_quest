import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/model/token_info.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/util/service/storage_service.dart';

class DefaultInterceptor extends Interceptor {
  final Ref ref;
  DefaultInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    await _addAuthTokenIfNeeded(options);
    log('[Request] ${options.method} ${options.path}');
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    log('[Error] ${err.response?.statusCode} - ${err.requestOptions.path}');

    // 자동 재시도를 건너뛸 요청들
    if (_shouldSkipAutoRetry(err.requestOptions)) {
      log('[Skip] 자동 재시도 건너뛰기: ${_getSkipReason(err.requestOptions)}');
      handler.next(err);
      return;
    }

    // 401 에러 - 토큰 만료 처리
    if (_isTokenExpired(err) && !_isAlreadyRetried(err.requestOptions)) {
      final retrySuccess = await _handleTokenRefresh(err, handler);
      if (retrySuccess) return;
    }

    // 인증 오류 - 강제 로그아웃
    if (_shouldForceLogout(err)) {
      _performLogout();
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('[Response] ${response.statusCode} - ${response.requestOptions.path}');
    handler.next(response);
  }

  // ==================== Request 관련 ====================

  /// 필요시 인증 토큰 추가
  Future<void> _addAuthTokenIfNeeded(RequestOptions options) async {
    final authRequired = options.extra['authRequired'] ?? true;
    if (!authRequired) return;

    final storage = ref.read(storageProvider);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  // ==================== Error 판단 로직 ====================

  /// 자동 재시도를 건너뛸지 판단
  bool _shouldSkipAutoRetry(RequestOptions options) {
    return options.extra['disableRetry'] == true;
  }

  /// 재시도 건너뛰는 이유 반환
  String _getSkipReason(RequestOptions options) {
    if (options.extra['disableRetry'] == true) return 'disableRetry 플래그';
    if (options.data is FormData) return 'FormData 요청';
    return '알 수 없음';
  }

  /// 토큰 만료 에러인지 확인
  bool _isTokenExpired(DioException err) {
    return err.response?.statusCode == 401;
  }

  /// 이미 재시도한 요청인지 확인
  bool _isAlreadyRetried(RequestOptions options) {
    return options.extra['retried'] == true;
  }

  /// 강제 로그아웃이 필요한지 판단
  bool _shouldForceLogout(DioException err) {
    return err.response?.statusCode == 403 ||
        (_isTokenExpired(err) && _isAlreadyRetried(err.requestOptions));
  }

  // ==================== Token Refresh 로직 ====================

  /// 토큰 갱신 및 재시도 처리
  Future<bool> _handleTokenRefresh(
      DioException err, ErrorInterceptorHandler handler) async {
    log('[Token] 토큰 갱신 시도');

    final refreshSuccess = await _refreshAccessToken();
    if (!refreshSuccess) {
      log('[Token] 토큰 갱신 실패 - 강제 로그아웃 처리');
      _performLogout(); // 🎯 토큰 갱신 실패시 로그아웃
      return false;
    }

    await _retryRequestWithNewToken(err, handler);
    return true;
  }

  /// Access Token 갱신
  Future<bool> _refreshAccessToken() async {
    try {
      final storage = ref.read(storageProvider);
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      if (refreshToken == null) {
        log('[Token] 리프레시 토큰 없음');
        return false;
      }

      final response = await _createRefreshDio().post(
        '/auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      return await _saveNewTokenFromResponse(response, storage);
    } on DioException catch (e) {
      // 🎯 401/403 에러는 리프레시 토큰 만료를 의미
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        log('[Token] 리프레시 토큰 만료: ${e.response?.data}');
        return false; // 상위에서 로그아웃 처리
      }

      log('[Token] 갱신 중 에러: $e');
      return false;
    } catch (e) {
      log('[Token] 갱신 중 예상치 못한 에러: $e');
      return false;
    }
  }

  /// 응답에서 새 토큰 저장
  Future<bool> _saveNewTokenFromResponse(
      Response response, StorageService storage) async {
    final data = response.data;
    if (data['code'] != "200" || data['data'] == null) {
      log('[Token] 잘못된 응답: ${data['message']}');
      return false;
    }

    final accessResponse = AccessResponse.fromJson(data['data']);
    await storage.write(
        key: ACCESS_TOKEN_KEY, value: accessResponse.access.token);

    log('[Token] 토큰 갱신 성공');
    return true;
  }

  /// 새 토큰으로 요청 재시도
  Future<void> _retryRequestWithNewToken(
      DioException err, ErrorInterceptorHandler handler) async {
    try {
      log('[Retry] 새 토큰으로 재시도: ${err.requestOptions.path}');

      final newToken =
          await ref.read(storageProvider).read(key: ACCESS_TOKEN_KEY);
      final retryOptions = _createRetryOptions(err.requestOptions, newToken!);

      final response = await _createRetryDio().fetch(retryOptions);
      log('[Retry] 재시도 성공');
      handler.resolve(response);
    } catch (e) {
      log('[Retry] 재시도 실패: $e');
      handler.next(err);
    }
  }

  /// 재시도용 RequestOptions 생성
  RequestOptions _createRetryOptions(RequestOptions original, String newToken) {
    return original.copyWith(
      extra: {...original.extra, 'retried': true},
    )..headers['Authorization'] = 'Bearer $newToken';
  }

  // ==================== Logout 처리 ====================

  /// 강제 로그아웃 실행
  void _performLogout() {
    log('[Auth] 인증 오류로 강제 로그아웃');
    Future.microtask(() => ref.read(authProvider.notifier).logout());
  }

  // ==================== Dio 인스턴스 생성 ====================

  /// 토큰 갱신용 Dio 인스턴스
  Dio _createRefreshDio() {
    return Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  /// 재시도용 Dio 인스턴스
  Dio _createRetryDio() {
    return Dio(BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }
}
