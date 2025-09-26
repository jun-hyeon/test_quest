import 'dart:developer' show log;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/auth/model/signup_form.dart';
import 'package:test_quest/auth/provider/signup_state.dart';
import 'package:test_quest/auth/repository/auth_repository.dart';
import 'package:test_quest/auth/repository/auth_repository_impl.dart';
import 'package:test_quest/util/validator.dart';

final signupProvider = NotifierProvider<SignupProvider, SignupState>(
  SignupProvider.new,
);

class SignupProvider extends Notifier<SignupState> {
  late final AuthRepository _authRepository;
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
    _authRepository = ref.read(authRepositoryProvider);
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
      // network call
      log('Signed up with email: $_email, password: $_password, nickname: $_nickname, name: $_name, profileImg: ${_image?.path}');
      final response = await _authRepository.signup(
        data: SignupForm(
          email: _email,
          password: _password,
          nickname: _nickname,
          name: _name,
          profileImage: _image != null ? File(_image!.path).path : null,
        ),
      );
      if (response.code != '200') {
        log('[signup_provider] 회원가입 실패');
        throw '회원가입 실패';
      }
      state = SignupSuccess();
    } catch (e) {
      state = SignupError(e.toString());
      log('[signup_provider] 회원가입 실패');
      throw '회원가입 실패';
    }
  }

  // void goToProfileStep() {
  //   state = const SignupInitial(step: SignupStep.profile);
  // }

  String? validateEmail(String? value) => Validator.validateEmail(value);
  String? validatePassword(String? value) => Validator.validatePassword(value);
  String? validateConfirmPassword(String? value, String original) =>
      Validator.validateConfirmPassword(value, original);
  String? validateNickname(String? value) => Validator.validateNickname(value);
  String? validateName(String? value) => Validator.validateName(value);
}
