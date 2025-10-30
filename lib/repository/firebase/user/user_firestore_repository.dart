import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/repository/firebase/user/user_repository.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/util/service/firebase_service.dart';

final userFirestoreRepositoryProvider =
    Provider<UserFirestoreRepositoryImpl>((ref) {
  final firebaseService = ref.read(firebaseServiceProvider);
  return UserFirestoreRepositoryImpl(firebaseService);
});

class UserFirestoreRepositoryImpl implements UserRepository {
  final FirebaseService _firebaseService;

  UserFirestoreRepositoryImpl(this._firebaseService);

  @override
  Future<void> setUser(UserInfo user) async {
    await _firebaseService.firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toJson());
  }

  @override
  Future<void> deleteUser(String uid) async {
    await _firebaseService.firestore.collection('users').doc(uid).delete();
  }

  @override
  Future<void> updateUser(UserInfo user) async {
    await _firebaseService.firestore
        .collection('users')
        .doc(user.uid)
        .update(user.toJson());
  }

  @override
  Future<UserInfo?> getUser(String uid) async {
    final doc =
        await _firebaseService.firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      return null;
    }
    return UserInfo.fromJson(doc.data()!);
  }

  @override
  Future<UserInfo> getCurrentUser() async {
    final currentUser = _firebaseService.auth.currentUser;
    if (currentUser == null) {
      throw Exception('로그인된 사용자가 없습니다.');
    }
    final doc = await _firebaseService.firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (!doc.exists) {
      throw Exception('사용자 정보를 찾을 수 없습니다.');
    }
    return UserInfo.fromJson(doc.data()!);
  }
}
