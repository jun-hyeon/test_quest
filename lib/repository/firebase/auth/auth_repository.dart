import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_quest/auth/model/signup_form.dart';

abstract class AuthRepository {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> signup({required SignupForm data});
  Future<void> logout();
  Future<void> deleteAccount();
  User? getCurrentUser();
  Stream<User?> authStateChanges();
  Future<UserCredential> signInWithGoogle();
  Future<UserCredential> signInWithApple();
}
