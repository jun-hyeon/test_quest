// lib/screens/signup/account_signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/user/provider/signup_provider.dart';
import 'package:test_quest/user/provider/signup_state.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final nicknameController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    _listenSignupState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    nicknameController.dispose();
    nameController.dispose();
    selectedImage = null; // Clear the selected image
    _formKey.currentState?.reset(); // Reset the form state

    super.dispose();
  }

  void _listenSignupState() {
    ref.listenManual<SignupState>(signupProvider, (previous, next) {
      if (next is SignupSuccess) {
        if (!mounted) return;
        TestQuestSnackbar.show(context, '회원가입이 완료되었습니다.');
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else if (next is SignupError) {
        if (!mounted) return;
        TestQuestSnackbar.show(context, next.message, isError: true);
      }
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
            Expanded(child: _buildFormFields(context, notifier)),
          ],
        ),
      SignupInitial(:final step) =>
        _buildFormFields(context, notifier, step: step),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildFormFields(BuildContext context, SignupProvider notifier,
      {SignupStep step = SignupStep.account}) {
    return Form(
      key: _formKey,
      child: switch (step) {
        SignupStep.account => _buildAccountFields(context, notifier),
        SignupStep.profile => _buildProfileFields(context, notifier),
      },
    );
  }

  Widget _buildAccountFields(BuildContext context, SignupProvider notifier) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Column(
      children: [
        const SizedBox(height: 20),
        Text('계정 정보를 입력하세요', style: TextStyle(fontSize: 14, color: textColor)),
        const SizedBox(height: 20),
        CustomTextfield(
          obscure: false,
          labelText: '이메일',
          controller: emailController,
          prefixIcon: Icons.email_outlined,
          validator: notifier.validateEmail,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          obscure: true,
          labelText: '비밀번호',
          controller: passwordController,
          prefixIcon: Icons.lock_open_outlined,
          validator: notifier.validatePassword,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          obscure: true,
          labelText: '비밀번호 확인',
          controller: confirmController,
          prefixIcon: Icons.lock_outline,
          validator: (value) =>
              notifier.validateConfirmPassword(value, passwordController.text),
        ),
        const SizedBox(height: 24),
        const Spacer(),
        CustomButton(
          text: '다음',
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;
            notifier.setEmailPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            notifier.goToProfileStep();
          },
        ),
      ],
    );
  }

  Widget _buildProfileFields(BuildContext context, SignupProvider notifier) {
    return Column(
      children: [
        const SizedBox(height: 16),
        ProfilePicker(selectedImage: selectedImage),
        const SizedBox(height: 16),
        TextButton(
          onPressed: pickImage,
          child: const Text('프로필 이미지 선택'),
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: nicknameController,
          obscure: false,
          labelText: '닉네임',
          prefixIcon: Icons.person,
          validator: notifier.validateNickname,
        ),
        const SizedBox(height: 16),
        CustomTextfield(
          controller: nameController,
          obscure: false,
          labelText: '이름',
          prefixIcon: Icons.tag_faces,
          validator: notifier.validateName,
        ),
        const SizedBox(height: 24),
        const Spacer(),
        CustomButton(
          text: '회원가입 완료',
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;
            notifier.setProfile(
              nickname: nicknameController.text,
              name: nameController.text,
              image: selectedImage,
            );
            notifier.signup();
          },
        ),
      ],
    );
  }
}
