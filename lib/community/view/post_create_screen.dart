import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/post_provider.dart';
import 'package:test_quest/util/service/image_picker_service.dart';

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

  TestType? _selectedType;
  TestPlatform? _selectedPlatform;

  XFile? _selectedImage;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    ref.listenManual(postProvider, (previous, next) {
      if (next is PostSuccess) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '글이 성공적으로 등록되었습니다!',
            isError: false,
          );
          context.pop();
        }
      } else if (next is PostError) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '업로드에 실패했습니다. 다시 시도해주세요.',
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

  void onDatePick(ValueSetter<DateTime> onPicked) async {
    final picked = await showDatePicker(
      locale: const Locale('ko', 'KR'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => onPicked(picked));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPlatform == null ||
        _selectedType == null ||
        startDate == null ||
        endDate == null) {
      return;
    }

    ref.read(postProvider.notifier).createPost(
          title: _titleController.text.trim(),
          description: _contentController.text.trim(),
          platform: _selectedPlatform!,
          type: _selectedType!,
          linkUrl: _linkController.text.trim(),
          startDate: startDate!,
          endDate: endDate!,
          boardImage: _selectedImage,
        );
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postProvider);
    final isLoading = state is PostLoading;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('글 작성'),
        ),
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
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '제목을 입력하세요'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DatePickerButton(
                          text: '시작일',
                          startDate: startDate,
                          onDatePick: () {
                            onDatePick((picked) => startDate = picked);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DatePickerButton(
                          text: '마감일',
                          startDate: endDate,
                          onDatePick: () {
                            onDatePick((picked) => endDate = picked);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField2<TestPlatform>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (_selectedPlatform == null) {
                          return '플랫폼을 선택해주세요';
                        }
                        return null;
                      },
                      hint: const Text('플랫폼을 선택해주세요'),
                      items: TestPlatform.values.map((platform) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          value: platform,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(platform.name)),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          _selectedPlatform = item;
                        });
                      }),
                  const SizedBox(height: 16),
                  DropdownButtonFormField2<TestType>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (_selectedType == null) {
                          return '테스트 타입을 선택해주세요';
                        }
                        return null;
                      },
                      hint: const Text('테스트 타입을 선택해주세요'),
                      items: TestType.values.map((type) {
                        return DropdownMenuItem(
                          alignment: Alignment.center,
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          _selectedType = item;
                        });
                      }),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: pickImage,
                    child: _selectedImage != null
                        ? Image.file(
                            fit: BoxFit.fill,
                            File(_selectedImage!.path),
                            width: double.infinity,
                            height: 200,
                          )
                        : Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor,
                              ),
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text('사진을 추가하려면 탭하세요'),
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.top,
                      textAlign: TextAlign.start,
                      controller: _contentController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: '내용을 입력해주세요'),
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
                    validator: (value) => value == null || value.trim().isEmpty
                        ? '링크를 입력해주세요'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('등록하기'),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  const _DatePickerButton({
    required this.startDate,
    required this.onDatePick,
    required this.text,
  });

  final DateTime? startDate;
  final VoidCallback? onDatePick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDatePick,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          startDate != null ? formatToYMD(startDate!) : '$text 선택',
        ),
      ),
    );
  }
}
