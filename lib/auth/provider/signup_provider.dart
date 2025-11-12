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
      log(
        'Signed up with email: $_email, password: $_password, nickname: $_nickname, name: $_name, profileImg: ${_image?.path}',
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

      String? profileUrl;
      if (_image != null) {
        profileUrl = await _storageRepository.uploadProfileImage(
          userId: user.uid,
          imageFile: File(_image!.path),
        );
        await user.updatePhotoURL(profileUrl);
      }

      await user.updateDisplayName(_nickname);
      await user.reload();

      final userInfo = UserInfo(
        uid: user.uid,
        name: _name,
        nickname: _nickname,
        profileUrl: profileUrl,
      );

      await _userRepository.setUser(userInfo);
      ref.read(userNotifierProvider.notifier).hydrate(userInfo);

      state = SignupSuccess();
    } catch (e, stackTrace) {
      log(
        '[signup_provider] 회원가입 실패',
        error: e,
        stackTrace: stackTrace,
      );
      state = SignupError(e.toString());
    }
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
