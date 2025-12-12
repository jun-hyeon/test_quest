import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/comment/view/comment_list_widget.dart';

class CommentSectionWidget extends ConsumerStatefulWidget {
  const CommentSectionWidget({super.key, required this.postId});

  final String postId;

  @override
  ConsumerState<CommentSectionWidget> createState() =>
      _CommentListWidgetState();
}

class _CommentListWidgetState extends ConsumerState<CommentSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '댓글',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),

        const Divider(height: 1),

        CommentListWidget(postId: widget.postId),
      ],
    );
  }
}
