import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/test_post_pagination_provider.dart';
import 'package:test_quest/repository/firebase/community/community_firestore.dart';
import 'package:test_quest/repository/firebase/storage/storage_repository.dart';
import 'package:test_quest/repository/firebase/user/user_firestore_repository.dart';
import 'package:test_quest/repository/firebase/user/user_repository.dart';
import 'package:test_quest/util/service/notification_service.dart';

final postProvider = NotifierProvider<PostNotifier, PostState>(() {
  return PostNotifier();
});

sealed class PostState {
  const PostState();
  factory PostState.initial() = PostInitial;
  factory PostState.loading() = PostLoading;
  factory PostState.success() = PostSuccess;
  factory PostState.error(String message) = PostError;
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostSuccess extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostNotifier extends Notifier<PostState> {
  late CommunityFirestoreRepositoryImpl _repository;
  late NotificationService _notificationService;
  late StorageRepository _storageRepository;
  late UserRepository _userRepository;

  @override
  PostState build() {
    _repository = ref.read(communityFirestoreRepositoryProvider);
    _notificationService = ref.read(notiProvider);
    _storageRepository = ref.read(storageRepositoryProvider);
    _userRepository = ref.read(userFirestoreRepositoryProvider);

    return PostState.initial();
  }

  /// 글 생성
  Future<void> createPost({
    required String title,
    required String description,
    required TestPlatform platform,
    required TestType type,
    required String linkUrl,
    required DateTime startDate,
    required DateTime endDate,
    XFile? boardImage,
    List<dynamic>? content,
  }) async {
    state = PostState.loading();
    try {
      final user = await _userRepository.getCurrentUser();

      // Firestore 문서 ID를 먼저 생성하여 TestPost.id로 사용
      final docId = await _repository.generatePostId();
      String? imageUrl;
      if (boardImage != null) {
        imageUrl = await _storageRepository.uploadPostImage(
          postId: docId,
          imageFile: File(boardImage.path),
        );
      }
      final post = TestPost(
        id: docId,
        userId: user.uid,
        nickname: user.nickname,
        views: 0,
        title: title,
        description: description,
        platform: platform,
        type: type,
        linkUrl: linkUrl,
        startDate: startDate,
        endDate: endDate,
        thumbnailUrl: imageUrl,
        recruitStatus: DateTime.now().isBefore(endDate) ? '모집중' : '모집마감',
        createdAt: DateTime.now(),
        content: content,
      );

      await _repository.createPost(post);
      await _refreshCommunityList();

      // 글 작성 완료 알림 표시
      await _notificationService.showPostCreatedNotification(
        title: title,
      );

      // FCM 알림은 Firestore Trigger에서 자동으로 처리됨

      state = PostState.success();
    } catch (e) {
      log('Post creation failed: $e');
      state = PostState.error(e.toString());
    }
  }

  Future<TestPost?> getPost({required String id}) async {
    state = PostState.loading();
    try {
      final post = await _repository.getPost(id);
      log('Post get success: $post');
      state = PostState.success();
      return post;
    } catch (e) {
      log('Post get failed: $e');
      state = PostState.error(e.toString());
      return null;
    }
  }

  /// 글 수정
  Future<void> updatePost({
    required String id,
    required XFile? image,
    required String title,
    required String description,
    required TestPlatform platform,
    required TestType type,
    required String linkUrl,
    required DateTime startDate,
    required DateTime endDate,
    List<dynamic>? content,
  }) async {
    state = PostState.loading();
    try {
      final existingPost = await _repository.getPost(id);
      String? imageUrl;
      if (image != null) {
        imageUrl = await _storageRepository.uploadPostImage(
          postId: id,
          imageFile: File(image.path),
        );
      }
      final updatedPost = existingPost.copyWith(
        title: title,
        description: description,
        platform: platform,
        type: type,
        linkUrl: linkUrl,
        startDate: startDate,
        endDate: endDate,
        thumbnailUrl: imageUrl,
        content: content,
      );
      await _repository.updatePost(updatedPost);
      await _refreshCommunityList();
      state = PostState.success();
    } catch (e) {
      log('Post update failed: $e');
      state = PostState.error(e.toString());
    }
  }

  /// 글 삭제
  Future<void> deletePost(String id) async {
    state = PostState.loading();
    try {
      await _repository.deletePost(id);
      await _refreshCommunityList();
      state = PostState.success();
    } catch (e) {
      log('Post deletion failed: $e');
      state = PostState.error(e.toString());
    }
  }

  /// 커뮤니티 목록 새로고침
  Future<void> _refreshCommunityList() async {
    try {
      await ref.read(testPostPaginationProvider.notifier).refresh();
    } catch (e) {
      log('Community list refresh failed: $e');
    }
  }
}
