import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/util/service/storage_service.dart';

const _userInfoKey = 'userInfo';

/// 사용자 정보 에러 타입
enum UserError {
  notFound('저장된 사용자 정보가 없습니다'),
  parseError('사용자 정보 파싱에 실패했습니다'),
  storageError('저장소 접근에 실패했습니다');

  const UserError(this.message);
  final String message;
}

/// 사용자 정보 AsyncNotifier
class UserNotifier extends AsyncNotifier<UserInfo?> {
  late final StorageService _storage;

  @override
  Future<UserInfo?> build() async {
    // 의존성 주입 - build에서 한 번만 초기화
    _storage = ref.read(storageProvider);

    // 초기화 시 자동으로 사용자 정보 로드
    return await _loadUserFromStorage();
  }

  /// 사용자 정보 설정 및 저장
  Future<void> setUser(UserInfo user) async {
    // 낙관적 업데이트
    state = AsyncValue.data(user);

    try {
      await _storage.write(
        key: _userInfoKey,
        value: jsonEncode(user.toJson()),
      );
      log(
        '사용자 정보 저장 성공: ${user.nickname}',
        name: 'UserNotifier.setUser',
      );
    } catch (e, stackTrace) {
      log(
        '사용자 정보 저장 실패',
        name: 'UserNotifier.setUser',
        error: e,
        stackTrace: stackTrace,
      );

      // 저장 실패 시 에러 상태로 변경
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 사용자 정보 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadUserFromStorage());
  }

  /// 사용자 정보 삭제
  Future<void> deleteUser() async {
    try {
      await _storage.delete(key: _userInfoKey);

      state = const AsyncValue.data(null);
      log(
        '사용자 정보 삭제 완료',
        name: 'UserNotifier.deleteUser',
      );
    } catch (e, stackTrace) {
      log(
        '사용자 정보 삭제 실패',
        name: 'UserNotifier.deleteUser',
        error: e,
        stackTrace: stackTrace,
      );
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 사용자 정보 부분 업데이트
  Future<void> updateUser(UserInfo Function(UserInfo current) updater) async {
    final currentUser = await future;
    if (currentUser == null) {
      throw UserError.notFound;
    }

    final updatedUser = updater(currentUser);
    await setUser(updatedUser);
  }

  /// 저장소에서 사용자 정보 로드
  Future<UserInfo?> _loadUserFromStorage() async {
    try {
      final jsonStr = await _storage.read(key: _userInfoKey);

      if (jsonStr == null) {
        log(
          '저장된 사용자 정보 없음',
          name: 'UserNotifier._loadUserFromStorage',
        );
        return null;
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final user = UserInfo.fromJson(json);

      log(
        '사용자 정보 로드 성공: ${user.nickname}',
        name: 'UserNotifier._loadUserFromStorage',
      );
      return user;
    } catch (e, stackTrace) {
      log(
        '사용자 정보 로드 실패',
        name: 'UserNotifier._loadUserFromStorage',
        error: e,
        stackTrace: stackTrace,
      );
      throw UserError.storageError;
    }
  }
}

/// AsyncNotifierProvider 사용
final userNotifierProvider = AsyncNotifierProvider<UserNotifier, UserInfo?>(
  () => UserNotifier(),
);

/// 현재 사용자 정보를 동기적으로 가져오는 Provider
final currentUserProvider = Provider<UserInfo?>((ref) {
  final userAsync = ref.watch(userNotifierProvider);
  return userAsync.valueOrNull;
});

/// 사용자 로그인 여부 확인 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

/// 사용자 표시명 Provider
final userDisplayNameProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.nickname ?? '게스트';
});
