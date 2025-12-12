import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/comment/model/comment_model.dart';
import 'package:test_quest/comment/provider/comment_notifier_provider.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItemWidget extends ConsumerStatefulWidget {
  const CommentItemWidget({
    super.key,
    required this.commentModel,
    required this.postId,
  });

  final CommentModel commentModel;
  final String postId;

  @override
  ConsumerState<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends ConsumerState<CommentItemWidget> {
  bool _isEditing = false;
  late TextEditingController _editingController;

  @override
  void initState() {
    _editingController = TextEditingController(
      text: widget.commentModel.content,
    );
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final isMyComment = currentUser?.uid == widget.commentModel.userId;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                widget.commentModel.userProfileUrl != null &&
                    widget.commentModel.userProfileUrl!.isNotEmpty
                ? NetworkImage(widget.commentModel.userProfileUrl!)
                : null,
            child:
                widget.commentModel.userProfileUrl == null ||
                    widget.commentModel.userProfileUrl!.isEmpty
                ? Icon(Icons.person, size: 20, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(width: 12),
          // 댓글 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사용자 이름과 시간을 한 줄로
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.commentModel.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeago.format(
                        widget.commentModel.createdAt,
                        locale: 'ko',
                      ),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                // 댓글 내용 또는 수정 필드
                if (_isEditing)
                  Column(
                    children: [
                      TextField(
                        controller: _editingController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '댓글을 수정하세요',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _editingController.text =
                                    widget.commentModel.content;
                              });
                            },
                            child: const Text('취소'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                              });
                              _handleEdit();
                            },
                            child: const Text('저장'),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Text(
                    widget.commentModel.content,
                    style: const TextStyle(fontSize: 14, letterSpacing: -0.2),
                  ),
                // 수정 시간
                if (widget.commentModel.updatedAt != null && !_isEditing) ...[
                  const SizedBox(height: 4),
                  Text(
                    '수정됨: ${timeago.format(widget.commentModel.updatedAt!, locale: 'ko')}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          if (isMyComment)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[700]),
              iconSize: 16,
              onSelected: (value) {
                if (value == 'edit') {
                  setState(() {
                    _isEditing = true;
                  });
                } else if (value == 'delete') {
                  _showDeleteDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('수정')),
                const PopupMenuItem(value: 'delete', child: Text('삭제')),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _handleEdit() async {
    final content = _editingController.text.trim();
    if (content.isEmpty) return;

    await ref
        .read(commentProvider.notifier)
        .editComment(
          postId: widget.postId,
          commentId: widget.commentModel.id,
          content: content,
        );
  }

  // 댓글 삭제 확인 다이얼로그
  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('댓글 삭제'),
        content: const Text('정말 이 댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete() async {
    await ref
        .read(commentProvider.notifier)
        .deleteComment(
          postId: widget.postId,
          commentId: widget.commentModel.id,
        );
  }
}
