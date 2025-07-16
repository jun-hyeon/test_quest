import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/auth/repository/auth_repository.dart';
import 'package:test_quest/auth/repository/auth_repository_impl.dart';
import 'package:test_quest/common/const.dart';
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
      await _updateUserWithRetry(user);
    } catch (e, stackTrace) {
      log(
        '[user_repository_impl.dart] 프로필 업데이트 실패: $e, error: ${e.toString()}',
        name: 'UserRepositoryImpl.updateUser',
      );
      rethrow;
    }
  }

  /// 토큰 갱신을 포함한 프로필 업데이트
  Future<void> _updateUserWithRetry(UserInfo user) async {
    // FormData를 매번 새로 생성
    FormData formData = await _createFormData(user);

    // 요청 내용 상세 로깅
    log('=== 프로필 업데이트 요청 시작 ===');
    log('닉네임: ${user.nickname}');
    log('프로필 이미지: ${user.profileImg}');
    log('FormData fields: ${formData.fields.map((f) => '${f.key}: ${f.value}').join(', ')}');
    log('FormData files: ${formData.files.map((f) => '${f.key}: ${f.value.filename}').join(', ')}');

    try {
      // 첫 번째 시도 (retry 비활성화)
      final response = await dio.post(
        '/user/update',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          extra: {
            'disableRetry': true, // FormData 재사용 문제 방지
          },
        ),
      );

      await _handleUpdateResponse(response, user);
    } on DioException catch (e) {
      // 401 에러인 경우 토큰 갱신 후 재시도
      if (e.response?.statusCode == 401) {
        log('=== 토큰 만료, 수동 갱신 후 재시도 ===');
        await _refreshTokenAndRetry(user);
      } else {
        throw Exception('프로필 업데이트에 실패했습니다: ${e.response?.statusCode}');
      }
    }
  }

  /// 토큰 갱신 후 재시도
  Future<void> _refreshTokenAndRetry(UserInfo user) async {
    try {
      // AuthRepository를 통해 토큰 갱신 (자동으로 스토리지에 저장됨)
      await authRepository.refresh();
      log('=== 토큰 갱신 완료 ===');

      // 🎯 새로 저장된 토큰 읽기
      final newAccessToken = await storage.read(key: ACCESS_TOKEN_KEY);

      if (newAccessToken == null) {
        throw Exception('토큰 갱신 후 토큰을 찾을 수 없습니다.');
      }

      // 새로운 FormData로 재시도
      final newFormData = await _createFormData(user);
      log('=== 토큰 갱신 후 재시도 ===');

      final response = await dio.post(
        '/user/update',
        data: newFormData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $newAccessToken', // 🎯 새 토큰 직접 설정
          },
          extra: {
            'disableRetry': true,
          },
        ),
      );

      await _handleUpdateResponse(response, user);
    } catch (e) {
      log('=== 토큰 갱신 후 재시도도 실패: $e ===');
      throw Exception('프로필 업데이트에 실패했습니다: 토큰 갱신 후에도 실패');
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
