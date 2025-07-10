import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/user/provider/auth_state.dart';
import 'package:test_quest/user/repository/auth_repository.dart';
import 'package:test_quest/user/repository/auth_repository_impl.dart';
import 'package:test_quest/util/service/storage_service.dart';
import 'package:test_quest/util/validator.dart';

final authProvider = NotifierProvider<AuthProvider, AuthState>(
  AuthProvider.new,
);

class AuthProvider extends Notifier<AuthState> {
  late final AuthRepository _authRepository;

  String _email = '';
  String _password = '';

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);

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
      final storage = ref.read(storageProvider);
      await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
      state = Authenticated();
    } catch (e) {
      state = Unauthenticated(errorMessage: e.toString());
      log('[auth_provider] Login failed: $e', error: e);
    }
  }

  Future<void> logout() async {
    try {
      // await _authRepository.logout();
      final storage = ref.read(storageProvider);
      await storage.delete(key: ACCESS_TOKEN_KEY);
      await storage.delete(key: REFRESH_TOKEN_KEY);
      state = Unauthenticated();
    } catch (e) {
      log('[auth_provider] Logout failed: $e');
      state = Unauthenticated(errorMessage: e.toString());
    }
  }

  Future<void> checkLoginStatus() async {
    final storage = ref.read(storageProvider);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (accessToken != null && refreshToken != null) {
      state = Authenticated();
    } else {
      state = Unauthenticated();
    }
  }

  String? _validateEmail(String email) => Validator.validateEmail(email);

  String? _validatePassword(String password) =>
      Validator.validatePassword(password);
}
