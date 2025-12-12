import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/provider/auth_state.dart';
import 'package:test_quest/repository/firebase/auth/firebase_auth_repository_impl.dart';
import 'package:test_quest/repository/firebase/user/user_firestore_repository.dart';
import 'package:test_quest/util/validator.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  late final FirebaseAuthRepositoryImpl _authRepository;
  late final UserFirestoreRepositoryImpl _userRepository;

  String _email = '';
  String _password = '';

  @override
  AuthState build() {
    // 의존성 주입 - build에서 안전하게 초기화
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _userRepository = ref.read(userFirestoreRepositoryProvider);
    // Firebase Auth 상태 변화를 감지하여 자동으로 상태 업데이트
    _authRepository.authStateChanges().listen((User? user) {
      if (user != null) {
        // 사용자가 로그인된 경우
        state = Authenticated();
      } else {
        // 사용자가 로그아웃된 경우
        state = Unauthenticated();
      }
    });

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

    try {
      log('로그인 시작: $_email', name: 'AuthNotifier.login');
      final userCredential = await _authRepository.login(
        email: _email,
        password: _password,
      );

      if (userCredential.user != null) {
        log(
          'Firebase Auth 로그인 성공: ${userCredential.user!.uid}',
          name: 'AuthNotifier.login',
        );
        // 직접 사용자 데이터 로드
        state = Authenticated();
      } else {
        throw Exception('로그인 후 사용자 정보를 가져올 수 없습니다.');
      }
    } catch (e) {
      state = Unauthenticated(errorMessage: e.toString());
      log('로그인 실패', name: 'AuthNotifier.login', error: e);
    }
  }

  Future<void> logout() async {
    try {
      log('로그아웃 시작', name: 'AuthNotifier.logout');
      await _authRepository.logout();
      // Firebase Auth 상태 변화 리스너가 자동으로 처리
      log(
        '로그아웃 완료 - Router Provider가 자동으로 로그인 화면으로 리다이렉션',
        name: 'AuthNotifier.logout',
      );
      state = Unauthenticated();
    } catch (e) {
      log('로그아웃 실패', name: 'AuthNotifier.logout', error: e);
      state = Unauthenticated(errorMessage: e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      final currentUser = await _userRepository.getCurrentUser();
      await _authRepository.deleteAccount();
      await _userRepository.deleteUser(currentUser.uid);
      state = Unauthenticated();
    } catch (e) {
      state = Unauthenticated(errorMessage: e.toString());
    }
  }

  String? _validateEmail(String email) => Validator.validateEmail(email);

  String? _validatePassword(String password) =>
      Validator.validatePassword(password);
}
