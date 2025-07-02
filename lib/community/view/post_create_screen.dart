import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';

class PostCreateScreen extends ConsumerStatefulWidget {
  const PostCreateScreen({super.key});

  @override
  ConsumerState<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends ConsumerState<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _linkController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // final success = await ref
    //     .read(postFormProvider.notifier)
    //     .createPost(title: _titleController.text.trim(), content: _contentController.text.trim());

    setState(() => _isSubmitting = false);

    // if (success && context.mounted) {
    //   Navigator.of(context).pop(true); // return true to indicate success
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('글 작성'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextfield(
                    obscure: false,
                    controller: _titleController,
                    hintText: '제목',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '제목을 입력하세요'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    obscure: false,
                    controller: _linkController,
                    hintText: '링크',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '링크를 입력해주세요'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      controller: _contentController,
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
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
                  CustomButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('등록하기'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
