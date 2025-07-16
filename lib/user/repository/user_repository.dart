import 'package:test_quest/user/model/user_info.dart';

abstract class UserRepository {
  // 로컬 스토리지 관련
  Future<void> setUser(UserInfo user);
  Future<UserInfo?> getUser();
  Future<void> deleteUser();

  // 서버 통신 관련
  Future<UserInfo> getMyInfo();
  Future<void> updateUser(UserInfo user);
  Future<void> deleteAccount();
}
