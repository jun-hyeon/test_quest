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
  const SignupProfileScreen({
    super.key,
  });

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

  void _listenSignupState() {
    ref.listenManual<SignupState>(signupProvider, (previous, next) {
      if (next is SignupSuccess) {
        if (!mounted) return;
        TestQuestSnackbar.show(context, '회원가입이 완료되었습니다.');
        context.go('/root');
      } else if (next is SignupError) {
        if (!mounted) return;
        TestQuestSnackbar.show(context, next.message, isError: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listenSignupState();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 정보'),
      ),
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
      SignupLoading() => const Center(child: CircularProgressIndicator()),
      SignupError() => Column(
          children: [
            Expanded(child: _buildProfileFields(context, notifier)),
          ],
        ),
      SignupInitial() => _buildProfileFields(context, notifier),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildProfileFields(BuildContext context, SignupProvider notifier) {
    return SingleChildScrollView(
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('권한 필요'),
                      content:
                          const Text('프로필 이미지를 선택하려면 권한이 필요합니다.\n설정에서 허용해주세요.'),
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
            const SizedBox(height: 24),
            CustomButton(
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
          ],
        ),
      ),
    );
  }
}
