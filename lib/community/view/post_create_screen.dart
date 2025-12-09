import 'dart:developer';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/post_provider.dart';
import 'package:test_quest/repository/firebase/storage/storage_repository.dart';
import 'package:test_quest/util/service/image_picker_service.dart';
import 'package:uuid/uuid.dart';

enum PostFormMode { create, edit }

class PostCreateScreen extends ConsumerStatefulWidget {
  final PostFormMode mode;
  final TestPost? post;

  const PostCreateScreen({super.key, required this.mode, this.post});

  @override
  ConsumerState<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends ConsumerState<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _link;
  late final QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();

  TestType? _selectedType;
  TestPlatform? _selectedPlatform;
  XFile? _selectedImage;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    ref.listenManual(postProvider, (previous, next) {
      if (next is PostSuccess) {
        if (mounted) {
          TestQuestSnackbar.show(context, '글이 성공적으로 등록되었습니다!', isError: false);
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

    final p = widget.post;
    final isEdit = widget.mode == PostFormMode.edit;

    _title = TextEditingController(text: isEdit ? p!.title : '');
    _link = TextEditingController(text: isEdit ? p!.linkUrl : '');

    // QuillController 초기화
    if (isEdit && p!.content != null && p.content!.isNotEmpty) {
      // 기존 Delta 데이터로 초기화
      _quillController = QuillController(
        document: Document.fromJson(p.content!),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      // 새 문서로 초기화
      _quillController = QuillController.basic();
    }

    _selectedType = isEdit ? p!.type : null;
    _selectedPlatform = isEdit ? p!.platform : null;
    _startDate = isEdit ? p!.startDate : null;
    _endDate = isEdit ? p!.endDate : null;
  }

  @override
  void dispose() {
    _title.dispose();
    _link.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
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

    // Quill 에디터 내용 검증
    final plainText = _quillController.document.toPlainText().trim();
    if (plainText.isEmpty) {
      TestQuestSnackbar.show(context, '내용을 입력하세요', isError: true);
      return;
    }

    if (_selectedPlatform == null ||
        _selectedType == null ||
        _startDate == null ||
        _endDate == null) {
      return;
    }

    // 로컬 이미지를 Firebase에 업로드하고 Delta JSON의 경로를 교체
    final deltaJson = await _uploadImagesAndGetDelta();

    final notifier = ref.read(postProvider.notifier);
    if (widget.mode == PostFormMode.create) {
      notifier.createPost(
        title: _title.text.trim(),
        description: plainText,
        platform: _selectedPlatform!,
        type: _selectedType!,
        linkUrl: _link.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        boardImage: _selectedImage,
        content: deltaJson,
      );
    } else {
      notifier.updatePost(
        id: widget.post!.id,
        image: _selectedImage,
        title: _title.text.trim(),
        description: plainText,
        platform: _selectedPlatform!,
        type: _selectedType!,
        linkUrl: _link.text.trim(),
        startDate: _startDate!,
        endDate: _endDate!,
        content: deltaJson,
      );
    }
    if (!mounted) return;
    context.pop(); // 완료 후 돌아가기
  }

  // 로컬 이미지를 Firebase에 업로드하고 URL로 교체된 Delta JSON 반환
  Future<List<dynamic>> _uploadImagesAndGetDelta() async {
    final deltaJson = _quillController.document.toDelta().toJson();

    // Delta에서 모든 로컬 이미지 경로 추출
    final List<String> localImagePaths = [];
    for (final op in deltaJson) {
      final insert = op['insert'];
      if (insert is Map<String, dynamic> && insert.containsKey('image')) {
        final imagePath = insert['image'] as String;
        // http로 시작하지 않으면 로컬 파일
        if (!imagePath.startsWith('http')) {
          localImagePaths.add(imagePath);
        }
      }
    }

    // 로컬 이미지가 없으면 바로 반환
    if (localImagePaths.isEmpty) {
      return deltaJson;
    }

    // 로딩 표시
    if (mounted) {
      TestQuestSnackbar.show(context, '이미지 업로드 중...', isError: false);
    }

    try {
      final storageRepo = ref.read(storageRepositoryProvider);
      const uuid = Uuid();
      final tempPostId = 'post_${uuid.v4()}';

      // 모든 로컬 이미지를 Firebase에 업로드
      final Map<String, String> uploadedUrls = {};

      for (final localPath in localImagePaths) {
        final file = File(localPath);

        // 파일이 존재하는지 확인
        if (!file.existsSync()) {
          log('이미지 파일이 존재하지 않음: $localPath');
          continue;
        }

        final imageUrl = await storageRepo.uploadPostImage(
          postId: tempPostId,
          imageFile: file,
        );

        uploadedUrls[localPath] = imageUrl;
        log('이미지 업로드 완료: $localPath -> $imageUrl');
      }

      // Delta JSON을 가져와서 로컬 경로를 Firebase URL로 교체
      final List<Map<String, dynamic>> updatedDelta = [];

      for (final op in deltaJson) {
        final insert = op['insert'];
        if (insert is Map<String, dynamic> && insert.containsKey('image')) {
          final imagePath = insert['image'] as String;
          if (uploadedUrls.containsKey(imagePath)) {
            // 로컬 경로를 Firebase URL로 교체
            updatedDelta.add({
              'insert': {'image': uploadedUrls[imagePath]},
              if (op.containsKey('attributes')) 'attributes': op['attributes'],
            });
          } else {
            // 이미 URL이거나 업로드 실패한 이미지
            updatedDelta.add(op);
          }
        } else {
          updatedDelta.add(op);
        }
      }

      log('총 ${uploadedUrls.length}개의 이미지가 Firebase Storage에 업로드됨');
      return updatedDelta;
    } catch (e) {
      log('이미지 업로드 에러: $e');
      if (mounted) {
        TestQuestSnackbar.show(
          context,
          '이미지 업로드 실패: ${e.toString()}',
          isError: true,
        );
      }
      // 실패 시 원본 Delta 반환
      return deltaJson;
    }
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
        appBar: AppBar(title: const Text('글 작성')),
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
                      controller: _title,
                      hintText: '제목',
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? '제목을 입력하세요'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _DatePickerButton(
                            text: '시작일',
                            startDate: _startDate,
                            onDatePick: () {
                              onDatePick((picked) => _startDate = picked);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DatePickerButton(
                            text: '마감일',
                            startDate: _endDate,
                            onDatePick: () {
                              onDatePick((picked) => _endDate = picked);
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(platform.name),
                          ),
                        );
                      }).toList(),
                      onChanged: (item) {
                        setState(() {
                          _selectedPlatform = item;
                        });
                      },
                    ),
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
                      },
                    ),
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
                            ),
                    ),
                    const SizedBox(height: 16),
                    // QuillEditor 기본 구성
                    Column(
                      children: [
                        QuillSimpleToolbar(
                          controller: _quillController,
                          config: QuillSimpleToolbarConfig(
                            axis: Axis.horizontal,
                            showDividers: true,
                            multiRowsDisplay: false,
                            embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          height: 300,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: QuillEditor.basic(
                            controller: _quillController,
                            focusNode: _editorFocusNode,
                            config: QuillEditorConfig(
                              embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextfield(
                      obscure: false,
                      controller: _link,
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
                          : const Text('등록하기'),
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
        child: Text(startDate != null ? formatToYMD(startDate!) : '$text 선택'),
      ),
    );
  }
}
