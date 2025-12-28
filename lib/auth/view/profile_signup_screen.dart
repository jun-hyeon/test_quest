import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/auth/provider/signup_provider.dart';
import 'package:test_quest/auth/provider/signup_state.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/util/service/permission_service.dart';

class SignupProfileScreen extends ConsumerStatefulWidget {
  const SignupProfileScreen({super.key});

  @override
  ConsumerState<SignupProfileScreen> createState() => _ProfileStepFormState();
}

class _ProfileStepFormState extends ConsumerState<SignupProfileScreen> {
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  XFile? selectedImage;

  Future<bool> checkPhotoCameraPermission() async {
    final permission = ref.read(permissionProvider);
    final photoGranted = await permission.requestPhotoPermission();
    // final cameraGranted = await permission.requestCameraPermission();

    if (!photoGranted.isGranted) {
      return false;
    }
    return true;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  @override
  void initState() {
    super.initState();

    // 회원가입 상태가 초기 상태가 아니면 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(signupProvider);
      if (currentState is! SignupInitial) {
        ref.read(signupProvider.notifier).reset();
      }
    });
  }

  @override
  void dispose() {
    nicknameController.dispose();
    nameController.dispose();
    selectedImage = null;
    formKey.currentState?.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ ref.listen을 사용하여 상태 변화 감지
    ref.listen<SignupState>(signupProvider, (previous, next) {
      if (next is SignupSuccess) {
        TestQuestSnackbar.show(context, '회원가입이 완료되었습니다.');
        context.go('/root');
      } else if (next is SignupError) {
        TestQuestSnackbar.show(context, next.message, isError: true);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('프로필 정보')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return switch (state) {
      SignupLoading(:final message, :final step, :final totalSteps) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '$step / $totalSteps 단계',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withAlpha(153), // 0.6 * 255
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: LinearProgressIndicator(
                value: step / totalSteps,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      SignupError(:final message) => Column(
        children: [
          // ✅ 에러 메시지 표시
          if (message.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildProfileFields(context, notifier)),
        ],
      ),
      SignupInitial() => _buildProfileFields(context, notifier),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildProfileFields(BuildContext context, SignupProvider notifier) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  ProfilePicker(selectedImage: selectedImage),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final granted = await checkPhotoCameraPermission();
                      if (!mounted) return;
                      if (!granted) {
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('권한 필요'),
                            content: const Text(
                              '프로필 이미지를 선택하려면 권한이 필요합니다.\n설정에서 허용해주세요.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  openAppSettings();
                                  context.pop();
                                },
                                child: const Text('설정으로 이동'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }
                      await pickImage();
                    },
                    child: const Text('프로필 이미지 선택'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: nicknameController,
                    obscure: false,
                    labelText: '닉네임',
                    prefixIcon: Icons.tag_faces,
                    validator: notifier.validateNickname,
                  ),
                  const SizedBox(height: 16),
                  CustomTextfield(
                    controller: nameController,
                    obscure: false,
                    labelText: '이름',
                    prefixIcon: Icons.person,
                    validator: notifier.validateName,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CustomButton(
            child: const Text('회원가입 완료'),
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              notifier.setProfile(
                nickname: nicknameController.text,
                name: nameController.text,
                image: selectedImage,
              );
              notifier.signup();
            },
          ),
        ),
      ],
    );
  }
}
