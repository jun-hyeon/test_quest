import 'dart:developer' show log;
import 'dart:io';

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

  String get email => _email;
  String get password => _password;
  String get nickname => _nickname;
  String get name => _name;
  XFile? get image => _image;

  @override
  SignupState build() {
    _authRepository = ref.read(firebaseAuthRepositoryProvider);
    _userRepository = ref.read(userFirestoreRepositoryProvider);
    _storageRepository = ref.read(storageRepositoryProvider);
    return const SignupInitial();
  }

  void setEmailPassword({
    required String email,
    required String password,
  }) {
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
    state = SignupLoading();
    try {
      // Firebase Auth를 통한 회원가입
      log('Signed up with email: $_email, password: $_password, nickname: $_nickname, name: $_name, profileImg: ${_image?.path}');
      final result = await _authRepository.signup(
        data: SignupForm(
          email: _email,
          password: _password,
          nickname: _nickname,
          name: _name,
          profileImage: _image != null ? File(_image!.path).path : null,
        ),
      );

      // 회원가입 성공 후 Firestore에서 사용자 정보 가져오기
      if (result.user != null) {
        try {
          String? profileUrl;
          if (_image != null) {
            profileUrl = await _storageRepository.uploadProfileImage(
              userId: result.user!.uid,
              imageFile: File(_image!.path),
            );
          }
          final userInfo = UserInfo(
            uid: result.user!.uid,
            name: _name,
            nickname: _nickname,
            profileUrl: profileUrl,
          );
          await _userRepository.setUser(userInfo);

          state = SignupSuccess();
        } catch (e) {
          log('사용자 정보 가져오기 실패: $e');
          // Firestore에서 가져오기 실패 시 기본 정보로 설정
          state = SignupError(e.toString());
        }
      }
    } catch (e) {
      state = SignupError(e.toString());
      log('[signup_provider] 회원가입 실패: $e');
      throw '회원가입 실패: $e';
    }
  }

  /// 회원가입 상태 초기화
  void reset() {
    _email = '';
    _password = '';
    _nickname = '';
    _name = '';
    _image = null;
    state = const SignupInitial();
  }

  String? validateEmail(String? value) => Validator.validateEmail(value);
  String? validatePassword(String? value) => Validator.validatePassword(value);
  String? validateConfirmPassword(String? value, String original) =>
      Validator.validateConfirmPassword(value, original);
  String? validateNickname(String? value) => Validator.validateNickname(value);
  String? validateName(String? value) => Validator.validateName(value);
}
