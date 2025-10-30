import 'package:test_quest/user/model/user_info.dart';

abstract class UserRepository {
  Future<void> setUser(UserInfo user);
  Future<UserInfo?> getUser(String uid);
  Future<void> deleteUser(String uid);
  Future<void> updateUser(UserInfo user);
  Future<UserInfo> getCurrentUser();
}
