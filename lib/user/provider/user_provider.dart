import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/repository/firebase/storage/storage_repository.dart';
import 'package:test_quest/repository/firebase/user/user_firestore_repository.dart';
import 'package:test_quest/user/model/user_info.dart';

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

final userNotifierProvider = AsyncNotifierProvider<UserNotifier, UserInfo?>(
  () => UserNotifier(),
);

// 현재 사용자 정보만 가져오는 Provider
final currentUserProvider = Provider<UserInfo?>((ref) {
  return ref.watch(userNotifierProvider).value;
});

// 로그인 여부 확인 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// 사용자 정보 AsyncNotifier
class UserNotifier extends AsyncNotifier<UserInfo?> {
  late final UserFirestoreRepositoryImpl _userRepository;
  late final StorageRepository _storageRepository;
  @override
  Future<UserInfo?> build() async {
    // 의존성 주입 - build에서 한 번만 초기화
    _userRepository = ref.read(userFirestoreRepositoryProvider);
    _storageRepository = ref.read(storageRepositoryProvider);
    // 초기화 시 자동으로 사용자 정보 로드
    return await _loadUserFromFirestore();
  }

  /// 사용자 정보 설정 및 저장
  Future<void> setUser(UserInfo user) async {
    // 낙관적 업데이트
    state = AsyncValue.data(user);

    try {
      if (user.profileUrl != null) {
        await _storageRepository.uploadProfileImage(
          userId: user.uid,
          imageFile: File(user.profileUrl!),
        );
      }
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
    state = await AsyncValue.guard(() => _loadUserFromFirestore());
  }

  /// 사용자 정보 삭제 (로컬만)
  Future<void> deleteUser() async {
    try {
      await _userRepository.deleteUser(state.value?.uid ?? '');
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
    final currentUser = state.value;
    if (currentUser == null) {
      throw Exception('사용자 정보가 없습니다');
    }
    final updatedUser = updater(currentUser);

    try {
      String? profileUrl;
      if (updatedUser.profileUrl != null) {
        profileUrl = await _storageRepository.uploadProfileImage(
          userId: updatedUser.uid,
          imageFile: File(updatedUser.profileUrl!),
        );
      }
      await _userRepository
          .updateUser(updatedUser.copyWith(profileUrl: profileUrl));

      state = AsyncValue.data(updatedUser);

      log(
        '사용자 정보 업데이트 성공: ${updatedUser.nickname}',
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

  Future<UserInfo?> _loadUserFromFirestore() async {
    try {
      // Firestore에서 현재 사용자 정보 가져오기
      final user = await _userRepository.getCurrentUser();

      log(
        '사용자 정보 로드 성공: ${user.nickname}',
        name: 'UserNotifier._loadUserFromFirestore',
      );

      return user;
    } catch (e, stackTrace) {
      log(
        '사용자 정보 로드 실패',
        name: 'UserNotifier._loadUserFromFirestore',
        error: e,
        stackTrace: stackTrace,
      );
      state = AsyncValue.error(e, stackTrace);
      // 로그아웃 처리
      // ref.read(authProvider.notifier).logout();
      return null;
    }
  }
}
