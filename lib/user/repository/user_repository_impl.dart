import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/repository/auth_repository.dart';
import 'package:test_quest/auth/repository/auth_repository_impl.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/repository/user_repository.dart';
import 'package:test_quest/util/model/response_model.dart';
import 'package:test_quest/util/network/provider/dio_provider.dart';
import 'package:test_quest/util/service/storage_service.dart';

const _userInfoKey = 'userInfo';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.read(dioProvider);
  final storage = ref.read(storageProvider);
  final authRepository = ref.read(authRepositoryProvider);
  return UserRepositoryImpl(
      dio: dio, storage: storage, authRepository: authRepository); // ref 추가
});

class UserRepositoryImpl extends UserRepository {
  final Dio dio;
  final StorageService storage;
  final AuthRepository authRepository; // 추가

  UserRepositoryImpl({
    required this.dio,
    required this.storage,
    required this.authRepository,
  });

  @override
  Future<void> deleteUser() async {
    try {
      
      await storage.delete(key: _userInfoKey);
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
      rethrow;
    }
  }

  @override
  Future<UserInfo?> getUser() async {
    try {
      // 로컬 스토리지에서만 가져오기
      final jsonStr = await storage.read(key: _userInfoKey);
      if (jsonStr == null) {
        log(
          '로컬에 저장된 사용자 정보 없음',
          name: 'UserRepositoryImpl.getUser',
        );
        return null;
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final user = UserInfo.fromJson(json);

      log(
        '로컬에서 사용자 정보 로드 성공: ${user.nickname}',
        name: 'UserRepositoryImpl.getUser',
      );

      return user;
    } catch (e, stackTrace) {
      log(
        '로컬 사용자 정보 로드 실패',
        name: 'UserRepositoryImpl.getUser',
        error: e,
        stackTrace: stackTrace,
      );
      return null; // 로컬에서 실패하면 null 반환
    }
  }

  @override
  Future<void> setUser(UserInfo user) async {
    try {
      await storage.write(
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

      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserInfo user) async {
    try {
      // 간단하게 한 번만 시도
      final formData = await _createFormData(user);

      final response = await dio.post(
        '/user/update',
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      await _handleUpdateResponse(response, user);
    } catch (e) {
      log('프로필 업데이트 실패: $e');
      rethrow;
    }
  }

  /// 응답 처리 공통 로직
  Future<void> _handleUpdateResponse(Response response, UserInfo user) async {
    log('=== 서버 응답 ===');
    log('Status Code: ${response.statusCode}');
    log('Response Data: ${response.data}');

    final responseData = ResponseModel.fromJson(
      response.data,
      (json) => null,
    );

    if (responseData.code != '200') {
      throw Exception(responseData.message ?? '프로필 업데이트에 실패했습니다.');
    }

    // 서버 업데이트 성공 시 로컬 스토리지에도 저장
    await setUser(user);
    log('프로필 업데이트 성공: ${user.nickname}');
  }

  // FormData 생성을 별도 메서드로 분리
  Future<FormData> _createFormData(UserInfo user) async {
    final formData = FormData.fromMap({
      'nickname': user.nickname,
    });

    // 프로필 이미지가 있으면 추가
    if (user.profileImg != null && user.profileImg!.isNotEmpty) {
      if (user.profileImg!.startsWith('/') ||
          user.profileImg!.startsWith('file://')) {
        formData.files.add(
          MapEntry(
            'profileImage',
            await MultipartFile.fromFile(
              user.profileImg!,
              filename: user.profileImg!.split('/').last,
            ),
          ),
        );
      }
      // URL인 경우는 기존 이미지 유지 (변경 없음을 의미)
      else {
        formData.fields
            .add(MapEntry('profileImage', user.profileImg!)); // 필드명 변경
      }
    }

    return formData;
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // 서버에서 계정 삭제
      final response = await dio.delete('/user/delete');
      final responseData = ResponseModel.fromJson(
        response.data,
        (json) => null,
      );

      if (responseData.code != '200') {
        throw Exception(responseData.message);
      }

      // 서버 삭제 성공 시 로컬 스토리지도 삭제
      await deleteUser();

      log(
        '계정 삭제 성공',
        name: 'UserRepositoryImpl.deleteAccount',
      );
    } on DioException catch (e) {
      log(
        '[user_repository_impl.dart] 계정 삭제 실패: ${e.message}, error: ${e.error}',
        name: 'UserRepositoryImpl.deleteAccount',
      );
      throw Exception('계정 삭제에 실패했습니다.');
    } catch (e, stackTrace) {
      log(
        '계정 삭제 실패',
        name: 'UserRepositoryImpl.deleteAccount',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<UserInfo> getMyInfo() async {
    try {
      // 서버에서 최신 사용자 정보 가져오기
      final response = await dio.get('/user/getinfo');
      final responseData = ResponseModel<UserInfo>.fromJson(
        response.data,
        (json) => UserInfo.fromJson(json as Map<String, dynamic>),
      );

      if (responseData.data == null) {
        throw '서버에서 사용자 정보를 가져올 수 없습니다.';
      }

      final user = responseData.data!;
      log(
        '서버에서 사용자 정보 가져오기 성공: ${user.nickname}',
        name: 'UserRepositoryImpl.getMyInfo',
      );

      return user;
    } on DioException catch (e) {
      log(
        '[user_repository_impl.dart] 서버 사용자 정보 가져오기 실패: ${e.message}, error: ${e.error}',
        name: 'UserRepositoryImpl.getMyInfo',
      );
      throw Exception('서버에서 사용자 정보를 가져오는데 실패했습니다.');
    } catch (e, stackTrace) {
      log(
        '서버 사용자 정보 가져오기 실패',
        name: 'UserRepositoryImpl.getMyInfo',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
