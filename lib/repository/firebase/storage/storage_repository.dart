import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/util/service/firebase_service.dart';
import 'package:uuid/uuid.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(ref.read(firebaseServiceProvider));
});

class StorageRepository {
  final FirebaseService _firebaseService;
  static const _uuid = Uuid();
  StorageRepository(this._firebaseService);

  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    final storageRef = _firebaseService.storage.ref();
    if (!imageFile.existsSync()) {
      throw Exception('이미지 파일이 존재하지 않습니다.');
    }

    final fileSize = await imageFile.length();
    if (fileSize == 0) {
      throw Exception('이미지 파일이 비어있습니다: ${imageFile.path}');
    }

    try {
      // 현재 사용자 확인
      final currentUser = _firebaseService.auth.currentUser;
      log('현재 Firebase Auth 사용자: ${currentUser?.uid}');

      if (currentUser == null) {
        throw Exception('Firebase Auth에 로그인되지 않았습니다.');
      }

      final fileName = 'profile_${_uuid.v4()}.jpg';
      final storagePath = 'users/$userId/$fileName';

      // 메타데이터 설정
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': userId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      log('업로드 시작...');

      // 파일 업로드
      final uploadTask = storageRef
          .child(storagePath)
          .putFile(imageFile, metadata);
      log('UploadTask 생성됨: ${uploadTask.hashCode}');

      final snapshot = await uploadTask;
      log('업로드 완료, 상태: ${snapshot.state}');
      log('업로드된 파일 크기: ${snapshot.bytesTransferred} bytes');

      if (snapshot.state == TaskState.success) {
        log('다운로드 URL 요청 중...');
        final downloadUrl = await snapshot.ref.getDownloadURL();
        log('프로필 이미지 업로드 성공: $downloadUrl');
        return downloadUrl;
      } else {
        log('업로드 실패 상태: ${snapshot.state}');
        throw Exception('업로드가 완료되지 않았습니다. 상태: ${snapshot.state}');
      }
    } catch (e) {
      log('프로필 이미지 업로드 실패: $e');
      log('에러 타입: ${e.runtimeType}');
      if (e is FirebaseException) {
        log('Firebase 에러 코드: ${e.code}');
        log('Firebase 에러 메시지: ${e.message}');
        log('Firebase 에러 스택: ${e.stackTrace}');
      }
      throw Exception('프로필 이미지 업로드 실패: $e');
    }
  }

  /// 게시글 이미지 업로드
  Future<String> uploadPostImage({
    required String postId,
    required File imageFile,
  }) async {
    try {
      final storageRef = _firebaseService.storage.ref();
      final fileName = 'image_$postId.jpg';
      final ref = storageRef.child('posts/$postId/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'postId': postId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      final uploadTask = ref.putFile(imageFile, metadata);
      final snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        throw Exception('업로드가 완료되지 않았습니다. 상태: ${snapshot.state}');
      }
    } catch (e) {
      throw Exception('게시글 이미지 업로드 실패: $e');
    }
  }

  /// 이미지 삭제
  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _firebaseService.storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('이미지 삭제 실패: $e');
    }
  }

  /// 다운로드 URL 획득
  Future<String> getDownloadURL(String path) async {
    try {
      final ref = _firebaseService.storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('다운로드 URL 획득 실패: $e');
    }
  }
}
