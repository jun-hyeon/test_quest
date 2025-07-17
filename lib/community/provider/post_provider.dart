import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_create.dart';
import 'package:test_quest/community/model/test_post_update.dart';
import 'package:test_quest/community/provider/test_post_pagination_provider.dart';
import 'package:test_quest/community/repository/test_post_repository_impl.dart';
import 'package:test_quest/util/extensions/xfile_extension.dart';

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
  late final repository = ref.read(testPostRepositoryProvider);

  @override
  PostState build() {
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
  }) async {
    state = PostState.loading();
    try {
      final post = TestPostCreate(
        author: 'current_user', // 실제로는 currentUserProvider에서 가져옴
        title: title,
        description: description,
        platform: platform,
        type: type,
        linkUrl: linkUrl,
        startDate: startDate.toIso8601String(),
        endDate: endDate.toIso8601String(),
        recruitStatus: DateTime.now().isBefore(endDate) ? '모집중' : '모집마감',
        boardImage: boardImage?.toFile().path,
      );

      await repository.createPost(post);
      await _refreshCommunityList();
      state = PostState.success();
    } catch (e, st) {
      log('Post creation failed: $e');
      state = PostState.error(e.toString());
    }
  }

  /// 글 수정
  Future<void> updatePost({
    required String id,
    required String title,
    required String description,
    XFile? boardImage,
  }) async {
    state = PostState.loading();
    try {
      final post = TestPostUpdate(
        id: id,
        title: title,
        description: description,
        boardImage: boardImage?.toFile().path,
      );

      await repository.updatePost(id, post);
      await _refreshCommunityList();
      state = PostState.success();
    } catch (e, st) {
      log('Post update failed: $e');
      state = PostState.error(e.toString());
    }
  }

  /// 글 삭제
  Future<void> deletePost(String id) async {
    state = PostState.loading();
    try {
      await repository.deletePost(id);
      await _refreshCommunityList();
      state = PostState.success();
    } catch (e, st) {
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
