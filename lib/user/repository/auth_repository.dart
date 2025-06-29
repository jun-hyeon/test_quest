import 'package:test_quest/user/model/signup_form.dart';
import 'package:test_quest/user/model/token_bundle.dart';
import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/result.dart';

abstract class AuthRepository {
  Future<ResponseModel<TokenBundle>> login(
      {required String email, required String password});
  Future<ResponseModel> signup({required SignupForm data});
  Future<Result<void>> logout();
  Future<Result<void>> deleteAccount();
  Future<Result<void>> getMyInfo();
}
