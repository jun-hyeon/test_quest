import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/comment/provider/comment_list_provider.dart';
import 'package:test_quest/comment/view/comment_item_widget.dart';

class CommentListWidget extends ConsumerWidget {
  const CommentListWidget({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentListAsyncValue = ref.watch(commentListProvider(postId));
    return commentListAsyncValue.when(
      data: (comments) {
        if (comments.isEmpty) {
          return const Center(child: Text('댓글이 없습니다.'));
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final comment = comments[index];
            return CommentItemWidget(commentModel: comment, postId: postId);
          },
        );
      },
      error: (error, stackTrace) {
        return Center(child: Text('댓글을 불러오는 중 오류가 발생했습니다: $error'));
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
