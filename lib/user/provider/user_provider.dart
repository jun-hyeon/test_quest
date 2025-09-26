import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/repository/auth_repository.dart';
import 'package:test_quest/auth/repository/auth_repository_impl.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/repository/user_repository.dart';
import 'package:test_quest/user/repository/user_repository_impl.dart';

/// 사용자 정보 에러 타입
enum UserError {
  notFound('저장된 사용자 정보가 없습니다'),
  parseError('사용자 정보 파싱에 실패했습니다'),
  storageError('저장소 접근에 실패했습니다'),
  networkError('네트워크 오류가 발생했습니다'),
  updateError('사용자 정보 업데이트에 실패했습니다');

  const UserError(this.message);
  final String message;
}

/// 사용자 정보 AsyncNotifier
class UserNotifier extends AsyncNotifier<UserInfo?> {
  late final UserRepository _userRepository;
  late final AuthRepository _authRepository;

  @override
  Future<UserInfo?> build() async {
    // 의존성 주입 - build에서 한 번만 초기화
    _userRepository = ref.read(userRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    // 초기화 시 자동으로 사용자 정보 로드
    return await _loadUserFromStorage();
  }

  /// 사용자 정보 설정 및 저장
  Future<void> setUser(UserInfo user) async {
    // 낙관적 업데이트
    state = AsyncValue.data(user);

    try {
      await _userRepository.setUser(user);
      log(
        '사용자 정보 저장 성공: ${user.nickname}',
        name: 'UserNotifier.setUser',
      );
      state = AsyncValue.data(user);
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

  /// 사용자 정보 삭제 (로컬만)
  Future<void> deleteUser() async {
    try {
      // 로컬 사용자 정보만 삭제 (서버 API 호출하지 않음)
      await _userRepository.deleteUser();

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
      // 실패해도 상태는 null로 변경
      state = const AsyncValue.data(null);
    }
  }

  /// 계정 삭제 (서버 + 로컬)
  Future<void> deleteAccount() async {
    try {
      // 서버에 계정 삭제 요청
      await _authRepository.deleteAccount();

      // 로컬 사용자 정보 삭제
      await _userRepository.deleteUser();

      state = const AsyncValue.data(null);
      log(
        '계정 삭제 완료',
        name: 'UserNotifier.deleteAccount',
      );
    } catch (e, stackTrace) {
      log(
        '계정 삭제 실패',
        name: 'UserNotifier.deleteAccount',
        error: e,
        stackTrace: stackTrace,
      );
      // 실패해도 로컬은 정리
      try {
        await _userRepository.deleteUser();
        state = const AsyncValue.data(null);
      } catch (localError) {
        log('로컬 정리 실패: $localError');
        state = const AsyncValue.data(null);
      }
    }
  }

  /// 사용자 정보 부분 업데이트
  Future<void> updateUser(UserInfo Function(UserInfo current) updater) async {
    final currentUser = await future;
    if (currentUser == null) {
      throw UserError.notFound;
    }

    final updatedUser = updater(currentUser);

    // 낙관적 업데이트
    state = AsyncValue.data(updatedUser);

    try {
      await _userRepository.updateUser(updatedUser);

      // 서버 업데이트 성공 후 최신 정보로 동기화
      final latestUser = await _userRepository.getMyInfo();
      await _userRepository.setUser(latestUser); // 로컬에도 저장
      state = AsyncValue.data(latestUser);

      log(
        '사용자 정보 업데이트 및 동기화 성공: ${latestUser.nickname}',
        name: 'UserNotifier.updateUser',
      );
    } catch (e, stackTrace) {
      log(
        '사용자 정보 업데이트 실패',
        name: 'UserNotifier.updateUser',
        error: e,
        stackTrace: stackTrace,
      );

      // 실패 시 이전 상태로 롤백
      state = AsyncValue.data(currentUser);
      rethrow;
    }
  }

  /// 서버에서 최신 사용자 정보 가져오기
  Future<UserInfo> fetchUserFromServer() async {
    state = const AsyncValue.loading();

    try {
      final user = await _userRepository.getMyInfo();
      await _userRepository.setUser(user); // 로컬에도 저장
      state = AsyncValue.data(user);

      log(
        '서버에서 사용자 정보 가져오기 성공: ${user.nickname}',
        name: 'UserNotifier.fetchUserFromServer',
      );

      return user; // 사용자 정보 반환
    } catch (e, stackTrace) {
      log(
        '서버에서 사용자 정보 가져오기 실패',
        name: 'UserNotifier.fetchUserFromServer',
        error: e,
        stackTrace: stackTrace,
      );
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// 서버에서 사용자 정보 새로고침
  Future<void> refreshFromServer() async {
    await fetchUserFromServer();
  }

  /// 저장소에서 사용자 정보 로드
  Future<UserInfo?> _loadUserFromStorage() async {
    try {
      // 1. 로컬 스토리지에서 사용자 정보 로드 시도
      UserInfo? user = await _userRepository.getUser();

      if (user != null) {
        log(
          '사용자 정보 로드 성공: ${user.nickname}',
          name: 'UserNotifier._loadUserFromStorage',
        );
        return user;
      } else {
        log(
          '로컬에 저장된 사용자 정보 없음, 서버에서 불러오기 시도',
          name: 'UserNotifier._loadUserFromStorage',
        );

        // 2. 서버에서 사용자 정보 가져오기 시도
        try {
          user = await _userRepository.getMyInfo();
          // 서버에서 가져온 정보를 로컬에 저장
          await _userRepository.setUser(user);
          log(
            '서버에서 사용자 정보 로드 성공: ${user.nickname}',
            name: 'UserNotifier._loadUserFromStorage',
          );
          return user; // 서버에서 가져온 사용자 정보 반환
        } catch (serverError) {
          log(
            '서버에서 사용자 정보 로드 실패, 로그아웃 진행',
            name: 'UserNotifier._loadUserFromStorage',
            error: serverError,
          );

          // 3. 서버에서도 실패하면 로그아웃 처리
          ref.read(authRepositoryProvider).logout();
          return null;
        }
      }
    } catch (e, stackTrace) {
      log(
        '사용자 정보 로드 실패',
        name: 'UserNotifier._loadUserFromStorage',
        error: e,
        stackTrace: stackTrace,
      );
      ref.read(authRepositoryProvider).logout();
      return null; // 에러 발생 시 null 반환
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
  return userAsync.value;
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
