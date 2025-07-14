import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/util/service/storage_service.dart';

const _userInfoKey = 'userInfo';

final userProvider = NotifierProvider<UserNotifier, UserInfo?>(() {
  return UserNotifier();
});

class UserNotifier extends Notifier<UserInfo?> {
  late final storage = ref.read(storageProvider);
  @override
  UserInfo? build() {
    return null;
  }

  Future<void> setUser(UserInfo user) async {
    state = user;
    await storage.write(key: _userInfoKey, value: jsonEncode(user.toJson()));
  }

  Future<void> loadUser() async {
    final jsonStr = await storage.read(key: _userInfoKey);
    if (jsonStr != null) {
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      state = UserInfo.fromJson(json);
    } else {
      state = null;
      throw '유저 정보를 불러 올 수 없습니다.';
    }
  }

  Future<void> deleteUser() async {
    state = null;
    await storage.delete(key: _userInfoKey);
  }
}
