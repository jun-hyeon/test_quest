import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post.dart';

class PostEditScreen extends ConsumerStatefulWidget {
  final TestPost post;

  const PostEditScreen({super.key, required this.post});

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updatePost() async {
    final updatedPost = widget.post.copyWith(
      title: _titleController.text,
      description: _contentController.text,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: const InputDecoration(labelText: '내용'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _updatePost,
              child: const Text('수정 완료'),
            )
          ],
        ),
      ),
    );
  }
}
