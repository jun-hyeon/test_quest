import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/user/provider/auth_state.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/user/repository/auth_repository.dart';
import 'package:test_quest/user/repository/auth_repository_impl.dart';
import 'package:test_quest/util/service/storage_service.dart';
import 'package:test_quest/util/validator.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  late final StorageService _storage;

  String _email = '';
  String _password = '';

  @override
  AuthState build() {
    // 의존성 주입 - build에서 안전하게 초기화
    _authRepository = ref.read(authRepositoryProvider);
    _storage = ref.read(storageProvider);

    return Unauthenticated();
  }

  void updateEmail(String email) {
    _email = email;
    final error = _validateEmail(_email);
    if (error != null) {
      state = AuthFormInvalid(error, null);
    } else if (state is AuthFormInvalid) {
      state = AuthFormInvalid(null, (state as AuthFormInvalid).passwordError);
    }
  }

  void updatePassword(String password) {
    _password = password;
    final error = _validatePassword(_password);
    if (error != null) {
      state = AuthFormInvalid(null, error);
    } else if (state is AuthFormInvalid) {
      state = AuthFormInvalid((state as AuthFormInvalid).emailError, null);
    }
  }

  Future<void> login() async {
    final emailError = _validateEmail(_email);
    final passwordError = _validatePassword(_password);

    if (emailError != null || passwordError != null) {
      state = AuthFormInvalid(emailError, passwordError);
      return;
    }

    state = AuthLoading();
    // Simulate a network call for login

    try {
      final result =
          await _authRepository.login(email: _email, password: _password);

      final tokenBundle = result;

      // if (tokenBundle == null) {
      //   state = Unauthenticated(errorMessage: '이메일 또는 비밀번호가 잘못되었습니다.');
      //   return;
      // }

      final accessToken = tokenBundle.access.token;
      final refreshToken = tokenBundle.refresh.token;
      await _storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      await _storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

      final userInfo = await _authRepository.getMyInfo();
      await ref.read(userNotifierProvider.notifier).setUser(userInfo);

      state = Authenticated();
    } catch (e) {
      state = Unauthenticated(errorMessage: e.toString());
      log('로그인 실패', name: 'AuthNotifier.login', error: e);
    }
  }

  Future<void> logout() async {
    try {
      log('로그아웃 시작', name: 'AuthNotifier.logout');
      // await _authRepository.logout();
      await _storage.delete(key: ACCESS_TOKEN_KEY);
      await _storage.delete(key: REFRESH_TOKEN_KEY);
      await ref.read(userNotifierProvider.notifier).deleteUser();
      state = Unauthenticated();
      log('로그아웃 완료 - Router Provider가 자동으로 로그인 화면으로 리다이렉션',
          name: 'AuthNotifier.logout');
    } catch (e) {
      log('로그아웃 실패', name: 'AuthNotifier.logout', error: e);
      state = Unauthenticated(errorMessage: e.toString());
    }
  }

  Future<void> checkLoginStatus() async {
    log('로그인 상태 확인 시작', name: 'AuthNotifier.checkLoginStatus');
    final accessToken = await _storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await _storage.read(key: REFRESH_TOKEN_KEY);

    log('토큰 확인 - Access: ${accessToken != null ? "존재" : "없음"}, Refresh: ${refreshToken != null ? "존재" : "없음"}',
        name: 'AuthNotifier.checkLoginStatus');

    if (accessToken != null && refreshToken != null) {
      log('토큰 존재 → Authenticated 상태로 변경',
          name: 'AuthNotifier.checkLoginStatus');
      state = Authenticated();
    } else {
      log('토큰 없음 → Unauthenticated 상태로 변경',
          name: 'AuthNotifier.checkLoginStatus');
      state = Unauthenticated();
    }

    log('최종 상태: $state', name: 'AuthNotifier.checkLoginStatus');
  }

  String? _validateEmail(String email) => Validator.validateEmail(email);

  String? _validatePassword(String password) =>
      Validator.validatePassword(password);
}
