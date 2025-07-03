// lib/screens/signup/account_signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/user/provider/signup_provider.dart';
import 'package:test_quest/user/provider/signup_state.dart';
import 'package:test_quest/util/service/permission_service.dart';

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
  final formKey = GlobalKey<FormState>();
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    nicknameController.dispose();
    nameController.dispose();
    selectedImage = null; // Clear the selected image
    formKey.currentState?.reset(); // Reset the form state

    super.dispose();
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
            Expanded(child: _buildAccountFields(context, notifier)),
          ],
        ),
      SignupInitial() => _buildAccountFields(context, notifier),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildAccountFields(BuildContext context, SignupProvider notifier) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return Form(
      key: formKey,
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
            prefixIcon: Icons.lock_open_outlined,
            validator: notifier.validatePassword,
          ),
          const SizedBox(height: 16),
          CustomTextfield(
            obscure: true,
            labelText: '비밀번호 확인',
            controller: confirmController,
            prefixIcon: Icons.lock_outline,
            validator: (value) => notifier.validateConfirmPassword(
                value, passwordController.text),
          ),
          const SizedBox(height: 24),
          const Spacer(),
          CustomButton(
            child: const Text('다음'),
            onPressed: () {
              if (formKey.currentState?.validate() != true) return;
              notifier.setEmailPassword(
                email: emailController.text,
                password: passwordController.text,
              );
              context.push('/signup/profile');
            },
          ),
        ],
      ),
    );
  }
}
