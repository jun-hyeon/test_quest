import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_quest/auth/model/signup_form.dart';
import 'package:test_quest/repository/firebase/auth/auth_repository.dart';
import 'package:test_quest/util/service/firebase_service.dart';

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepositoryImpl>((
  ref,
) {
  return FirebaseAuthRepositoryImpl(ref.read(firebaseServiceProvider));
});

class FirebaseAuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;

  FirebaseAuthRepositoryImpl(this._firebaseService);

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseService.auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserCredential> signup({required SignupForm data}) async {
    log('=== 회원가입 시작 ===');
    log('이메일: ${data.email}');
    log('닉네임: ${data.nickname}');
    log('이름: ${data.name}');
    log('프로필 이미지: ${data.profileImage}');

    try {
      // 1. Firebase Auth에 계정 생성
      log('1️⃣ Firebase Auth 계정 생성 중...');
      final userCredential = await _firebaseService.auth
          .createUserWithEmailAndPassword(
            email: data.email,
            password: data.password,
          );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('사용자 생성에 실패했습니다.');
      }
      log('✅ Firebase Auth 계정 생성 성공: ${user.uid}');

      log('2️⃣ 프로필 이미지는 별도 단계에서 업로드됩니다.');
      log('=== Firebase Auth 프로필 업데이트 시작 ===');
      await user.updateDisplayName(data.nickname);
      log('✅ Firebase Auth displayName 업데이트 성공: ${data.nickname}');

      log('=== Firebase Auth 프로필 업데이트 완료 ===');

      log('🎉 회원가입 완료! 사용자 UID: ${user.uid}');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseService.auth.signOut();
    } catch (e) {
      throw Exception('로그아웃 실패: $e');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 1. Firestore에서 사용자 데이터 삭제
      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .delete();

      // 2. 사용자의 게시글들도 삭제 (선택사항 - 현재는 주석 처리 유지하거나 필요 시 활성화, 여기서는 사용자 요청에 따라 기본 데이터 삭제 활성화)
      /* 
      final postsQuery = await _firebaseService.firestore
          .collection('posts')
          .where('userId', isEqualTo: user.uid)
          .get();

      for (final doc in postsQuery.docs) {
        await doc.reference.delete();
      } 
      */

      //Firebase Auth에서 계정 삭제
      await user.delete();
    } catch (e) {
      throw Exception('계정 삭제 실패: $e');
    }
  }

  @override
  User? getCurrentUser() {
    return _firebaseService.auth.currentUser;
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseService.auth.authStateChanges();
  }

  /// Firebase Auth 예외 처리
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'weak-password':
        return '비밀번호가 너무 약합니다.';
      case 'invalid-email':
        return '유효하지 않은 이메일입니다.';
      case 'user-disabled':
        return '비활성화된 계정입니다.';
      case 'too-many-requests':
        return '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
      case 'operation-not-allowed':
        return '허용되지 않은 작업입니다.';
      default:
        return '인증 오류가 발생했습니다: ${e.message}';
    }
  }

  @override
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    if (kIsWeb) {
      return await FirebaseAuth.instance.signInWithPopup(appleProvider);
    } else {
      return await FirebaseAuth.instance.signInWithProvider(appleProvider);
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn.instance
        .authenticate();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
