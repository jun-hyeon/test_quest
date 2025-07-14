import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/model/test_post_create.dart';
import 'package:test_quest/community/repository/test_post_repository_impl.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/util/extensions/xfile_extension.dart';

final postCreateProvider =
    NotifierProvider<PostCreateNotifier, PostCreateState>(() {
  return PostCreateNotifier();
});

sealed class PostCreateState {
  const PostCreateState();
  factory PostCreateState.initial() = PostCreateInitial;
  factory PostCreateState.loading() = PostCreateLoading;
  factory PostCreateState.success() = PostCreateSuccess;
  factory PostCreateState.error(String message) = PostCreateError;
}

class PostCreateInitial extends PostCreateState {}

class PostCreateLoading extends PostCreateState {}

class PostCreateSuccess extends PostCreateState {}

class PostCreateError extends PostCreateState {
  final String message;
  PostCreateError(this.message);
}

class PostCreateNotifier extends Notifier<PostCreateState> {
  late final repository = ref.read(testPostRepositoryProvider);

  @override
  PostCreateState build() {
    return PostCreateState.initial();
  }

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
    state = PostCreateState.loading();
    try {
      await ref.read(userProvider.notifier).loadUser();
      final user = ref.read(userProvider);

      if (user == null) throw '유저를 찾을 수 없습니다.';

      final post = TestPostCreate(
        author: user.nickname,
        title: title,
        description: description,
        platform: platform,
        type: type,
        linkUrl: linkUrl,
        startDate: DateFormat('yyyy-MM-dd').format(startDate).toString(),
        endDate: DateFormat('yyyy-MM-dd').format(endDate).toString(),
        recruitStatus: DateTime.now().isBefore(endDate) ? '모집중' : '모집마감',
        boardImage: boardImage?.toFile().path,
      );

      log(post.toString());

      await repository.createPost(post);
      state = PostCreateState.success();
    } catch (e, st) {
      log('Post creation failed: $e');
      log('StackTrace: $st');
      state = PostCreateState.error(e.toString());
    }
  }
}
