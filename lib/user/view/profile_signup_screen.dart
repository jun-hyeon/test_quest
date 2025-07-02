import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/user/provider/signup_provider.dart';
import 'package:test_quest/user/provider/signup_state.dart';

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
      SignupError(:final message) => Column(
          children: [
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            Expanded(child: _buildProfileFields(context, notifier)),
          ],
        ),
      SignupInitial() => _buildProfileFields(context, notifier),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildProfileFields(BuildContext context, SignupProvider notifier) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          ProfilePicker(selectedImage: selectedImage),
          const SizedBox(height: 16),
          TextButton(onPressed: pickImage, child: const Text('프로필 이미지 선택')),
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
          const Spacer(),
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
    );
  }
}
