import 'dart:developer' show log;
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/auth/model/signup_form.dart';
import 'package:test_quest/auth/provider/signup_state.dart';
import 'package:test_quest/repository/firebase/auth/auth_repository.dart';
import 'package:test_quest/repository/firebase/auth/firebase_auth_repository_impl.dart';
import 'package:test_quest/repository/firebase/storage/storage_repository.dart';
import 'package:test_quest/repository/firebase/user/user_firestore_repository.dart';
import 'package:test_quest/repository/firebase/user/user_repository.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/util/validator.dart';

final signupProvider = NotifierProvider<SignupProvider, SignupState>(
  SignupProvider.new,
);

class SignupProvider extends Notifier<SignupState> {
  late final AuthRepository _authRepository;
  late final UserRepository _userRepository;
  late final StorageRepository _storageRepository;
  String _email = '';
  String _password = '';
  String _nickname = '';
  String _name = '';
  XFile? _image;
  bool _termsAgreed = false;
  bool _privacyAgreed = false;
  String _termsUrl = '';
  String _privacyUrl = '';

  String get email => _email;
  String get password => _password;
  String get nickname => _nickname;
  String get name => _name;
  XFile? get image => _image;
  bool get termsAgreed => _termsAgreed;
  bool get privacyAgreed => _privacyAgreed;
  String get termsUrl => _termsUrl;
  String get privacyUrl => _privacyUrl;

  @override
  SignupState build() {
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _userRepository = ref.read(userFirestoreRepositoryProvider);
    _storageRepository = ref.read(storageRepositoryProvider);
    return const SignupInitial();
  }

  void setEmailPassword({required String email, required String password}) {
    _email = email;
    _password = password;
  }

  void setProfile({
    required String nickname,
    required String name,
    required XFile? image,
  }) {
    _nickname = nickname;
    _name = name;
    _image = image;
  }

  Future<void> signup() async {
    // ✅ 약관 동의 검증
    if (!_termsAgreed) {
      state = const SignupError('이용약관에 동의해주세요');
      return;
    }

    if (!_privacyAgreed) {
      state = const SignupError('개인정보처리방침에 동의해주세요');
      return;
    }

    // 입력값 검증은 UI의 Form validation에서 처리

    // ✅ Rollback을 위한 사용자 참조
    firebase_auth.User? createdUser;

    try {
      // ✅ 보안: 비밀번호는 로깅하지 않음
      log(
        '[signup_provider] 회원가입 시작 - email: $_email, nickname: $_nickname, name: $_name',
        name: 'SignupProvider',
      );

      // 1단계: 계정 생성
      state = const SignupLoading(
        message: '계정을 생성하는 중...',
        step: 1,
        totalSteps: 6,
      );

      final credential = await _authRepository.signup(
        data: SignupForm(
          email: _email,
          password: _password,
          nickname: _nickname,
          name: _name,
          profileImage: _image?.path,
        ),
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Firebase Auth 사용자 정보를 가져올 수 없습니다.');
      }
      createdUser = user; // Rollback을 위해 참조 저장

      // 2단계: 프로필 이미지 업로드
      state = const SignupLoading(
        message: '프로필 이미지를 업로드하는 중...',
        step: 2,
        totalSteps: 6,
      );

      String? profileUrl;
      final image = _image; // ✅ Null safety 개선
      if (image != null) {
        profileUrl = await _storageRepository.uploadProfileImage(
          userId: user.uid,
          imageFile: File(image.path),
        );

        // 이미지 업로드 완료 확인
        if (profileUrl.isEmpty) {
          throw Exception('프로필 이미지 업로드에 실패했습니다.');
        }

        log(
          '[signup_provider] 프로필 이미지 업로드 완료 - URL: $profileUrl',
          name: 'SignupProvider',
        );
      }

      // 3단계: 프로필 업데이트 (순차 처리)
      state = const SignupLoading(
        message: '프로필을 업데이트하는 중...',
        step: 3,
        totalSteps: 6,
      );

      // 순차적으로 처리하여 확실하게 완료
      if (profileUrl != null) {
        await user.updatePhotoURL(profileUrl);
        log(
          '[signup_provider] Firebase Auth 프로필 이미지 URL 업데이트 완료',
          name: 'SignupProvider',
        );
      }

      await user.updateDisplayName(_nickname);
      log(
        '[signup_provider] Firebase Auth 닉네임 업데이트 완료',
        name: 'SignupProvider',
      );

      // 4단계: 사용자 정보 리로드
      state = const SignupLoading(
        message: '정보를 동기화하는 중...',
        step: 4,
        totalSteps: 6,
      );
      await user.reload();

      // 리로드 후 최신 사용자 정보 가져오기
      final reloadedUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (reloadedUser == null) {
        throw Exception('사용자 정보를 다시 불러오는데 실패했습니다.');
      }

      log(
        '[signup_provider] 사용자 정보 리로드 완료 - photoURL: ${reloadedUser.photoURL}, displayName: ${reloadedUser.displayName}',
        name: 'SignupProvider',
      );

      // 5단계: Firestore에 사용자 정보 저장
      state = const SignupLoading(
        message: '사용자 정보를 저장하는 중...',
        step: 5,
        totalSteps: 6,
      );

      final userInfo = UserInfo(
        uid: user.uid,
        name: _name,
        nickname: _nickname,
        profileUrl: profileUrl,
      );
      await _userRepository.setUser(userInfo);

      // 6단계: Provider에 사용자 정보 반영
      state = const SignupLoading(message: '완료하는 중...', step: 6, totalSteps: 6);
      ref.read(userNotifierProvider.notifier).hydrate(userInfo);

      state = const SignupSuccess();
      log('[signup_provider] 회원가입 성공', name: 'SignupProvider');
    } catch (e, stackTrace) {
      log(
        '[signup_provider] 회원가입 실패',
        error: e,
        stackTrace: stackTrace,
        name: 'SignupProvider',
      );

      // ✅ Rollback: 생성된 계정 삭제
      if (createdUser != null) {
        try {
          await createdUser.delete();
          log(
            '[signup_provider] 회원가입 실패로 인해 생성된 계정을 삭제했습니다.',
            name: 'SignupProvider',
          );
        } catch (deleteError) {
          log(
            '[signup_provider] 계정 삭제 중 오류 발생',
            error: deleteError,
            name: 'SignupProvider',
          );
        }
      }

      // ✅ 사용자 친화적인 에러 메시지
      state = SignupError(_getErrorMessage(e), stackTrace);
    }
  }

  /// ✅ 에러 메시지를 사용자 친화적인 한국어로 변환
  String _getErrorMessage(Object error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('email-already-in-use')) {
      return '이미 사용 중인 이메일입니다.';
    } else if (errorString.contains('weak-password')) {
      return '비밀번호가 너무 약합니다. 더 강력한 비밀번호를 사용해주세요.';
    } else if (errorString.contains('invalid-email')) {
      return '올바른 이메일 형식이 아닙니다.';
    } else if (errorString.contains('network')) {
      return '네트워크 연결을 확인해주세요.';
    } else if (errorString.contains('permission')) {
      return '권한이 부족합니다. 잠시 후 다시 시도해주세요.';
    } else if (errorString.contains('too-many-requests')) {
      return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
    }

    return '회원가입 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
  }

  void setTermsAgreed(bool agreed) {
    _termsAgreed = agreed;
  }

  void setPrivacyAgreed(bool agreed) {
    _privacyAgreed = agreed;
  }

  void setTermsUrl(String url) {
    _termsUrl = url;
  }

  void setPrivacyUrl(String url) {
    _privacyUrl = url;
  }

  /// 회원가입 상태 초기화
  void reset() {
    _email = '';
    _password = '';
    _nickname = '';
    _name = '';
    _image = null;
    _termsAgreed = false;
    _privacyAgreed = false;
    _termsUrl = '';
    _privacyUrl = '';
    state = const SignupInitial();
  }

  String? validateEmail(String? value) => Validator.validateEmail(value);
  String? validatePassword(String? value) => Validator.validatePassword(value);
  String? validateConfirmPassword(String? value, String original) =>
      Validator.validateConfirmPassword(value, original);
  String? validateNickname(String? value) => Validator.validateNickname(value);
  String? validateName(String? value) => Validator.validateName(value);
}
