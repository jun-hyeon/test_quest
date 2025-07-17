import 'package:test_quest/auth/model/signup_form.dart';
import 'package:test_quest/auth/model/token_bundle.dart';
import 'package:test_quest/auth/model/token_info.dart';
import 'package:test_quest/util/model/response_model.dart';

abstract class AuthRepository {
  Future<TokenBundle> login({required String email, required String password});
  Future<ResponseModel> signup({required SignupForm data});
  Future<AccessResponse> refresh();
  Future<void> logout();
  Future<void> deleteAccount();
}
