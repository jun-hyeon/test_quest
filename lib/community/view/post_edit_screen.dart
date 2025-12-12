import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/post_provider.dart';
import 'package:test_quest/util/service/image_picker_service.dart';

class PostEditScreen extends ConsumerStatefulWidget {
  final TestPost post;

  const PostEditScreen({super.key, required this.post});

  @override
  ConsumerState<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends ConsumerState<PostEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _linkController;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.description);
    _linkController = TextEditingController(text: widget.post.linkUrl);

    ref.listenManual(postProvider, (previous, next) {
      if (next is PostSuccess) {
        if (mounted) {
          TestQuestSnackbar.show(context, '글이 성공적으로 수정되었습니다!', isError: false);

          // 수정된 데이터와 함께 이전 화면으로 돌아가기
          final updatedPost = widget.post.copyWith(
            title: _titleController.text.trim(),
            description: _contentController.text.trim(),
            // 이미지는 서버에서 업데이트되므로 기존 URL 유지
            thumbnailUrl: widget.post.thumbnailUrl,
          );

          context.pop(updatedPost); // 수정된 데이터를 결과로 전달
        }
      } else if (next is PostError) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '수정에 실패했습니다. 다시 시도해주세요.',
            isError: true,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void pickImage() async {
    await ImagePickerService.pickAndSet(
      source: ImageSource.gallery,
      onImagePicked: (image) {
        setState(() {
          _selectedImage = image;
        });
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(postProvider.notifier)
        .updatePost(
          id: widget.post.id,
          image: _selectedImage,
          title: _titleController.text.trim(),
          description: _contentController.text.trim(),
          platform: widget.post.platform,
          type: widget.post.type,
          linkUrl: _linkController.text.trim(),
          startDate: widget.post.startDate,
          endDate: widget.post.endDate,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postProvider);
    final isLoading = state is PostLoading;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('글 수정')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomTextfield(
                      obscure: false,
                      controller: _titleController,
                      hintText: '제목',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? '제목을 입력하세요'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickImage,
                      child: _selectedImage != null
                          ? Image.file(
                              File(_selectedImage!.path),
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : (widget.post.thumbnailUrl != null &&
                                    widget.post.thumbnailUrl!.isNotEmpty &&
                                    widget.post.thumbnailUrl!.startsWith('http')
                                ? Image.network(
                                    widget.post.thumbnailUrl!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo_outlined,
                                            size: 48,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(height: 8),
                                          const Text('사진을 추가하려면 탭하세요'),
                                        ],
                                      ),
                                    ),
                                  )),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.start,
                        controller: _contentController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '내용을 입력해주세요',
                        ),
                        maxLines: null,
                        expands: true,
                        keyboardType: TextInputType.multiline,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? '내용을 입력하세요'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextfield(
                      obscure: false,
                      controller: _linkController,
                      hintText: '링크',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? '링크를 입력해주세요'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : const Text('수정 완료'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
