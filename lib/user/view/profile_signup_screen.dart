import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/user/provider/signup_provider.dart';
import 'package:test_quest/user/provider/signup_state.dart';

class ProfileSignupScreen extends ConsumerStatefulWidget {
  const ProfileSignupScreen({super.key});

  @override
  ConsumerState<ProfileSignupScreen> createState() =>
      _ProfileSignupScreenState();
}

class _ProfileSignupScreenState extends ConsumerState<ProfileSignupScreen> {
  XFile? selectedImage;

  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signupProvider);
    final notifier = ref.read(signupProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: switch (state) {
            SignupLoading() => const Center(child: CircularProgressIndicator()),
            SignupSuccess() => const Center(child: Text("회원가입 성공!")),
            SignupError(:final message) => Column(
                children: [
                  const SizedBox(height: 16),
                  Text(message, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  Expanded(child: _buildForm(context, notifier)),
                ],
              ),
            SignupInitial(:final step) =>
              _buildForm(context, notifier, step: step),
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, SignupProvider notifier,
      {SignupStep step = SignupStep.account}) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    if (step == SignupStep.account) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('계정 정보를 입력하세요',
                style: TextStyle(fontSize: 14, color: textColor)),
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
              prefixIcon: Icons.lock_outline,
              validator: notifier.validatePassword,
            ),
            const SizedBox(height: 16),
            CustomTextfield(
              obscure: true,
              labelText: '비밀번호 확인',
              controller: confirmController,
              validator: (value) => notifier.validateConfirmPassword(
                  value, passwordController.text),
            ),
            const SizedBox(height: 24),
            CustomButton(
              child: Text('다음'),
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
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: Column(
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
            CustomButton(
              child: const Text('회원가입 완료'),
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
        ),
      );
    }
  }
}
