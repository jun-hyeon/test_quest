// lib/screens/signup/account_signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_quest/auth/provider/signup_provider.dart';
import 'package:test_quest/auth/provider/signup_state.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _termsAgreed = false;
  bool _privacyAgreed = false;

  String get _termsUrl => dotenv.env['TERMS_URL'] ?? '';
  String get _privacyUrl => dotenv.env['PRIVACY_URL'] ?? '';

  @override
  void initState() {
    super.initState();
    // 회원가입 상태 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(signupProvider.notifier).reset();
    });
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

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL이 설정되지 않았습니다')));
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('올바른 URL 형식이 아닙니다')));
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL을 열 수 없습니다')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        top: true,
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
          Expanded(child: _buildAccountFields(context, notifier)),
        ],
      ),
      SignupInitial() => _buildAccountFields(context, notifier),
      SignupSuccess() => const SizedBox.shrink(),
    };
  }

  Widget _buildAccountFields(BuildContext context, SignupProvider notifier) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,

              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Text(
                    '계정 정보를 입력하세요',

                    style: TextStyle(fontSize: 14, color: textColor),
                  ),

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
                      value,

                      passwordController.text,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 이용약관 동의
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAgreed,

                        onChanged: (value) {
                          setState(() {
                            _termsAgreed = value ?? false;
                          });

                          notifier.setTermsAgreed(_termsAgreed);

                          notifier.setTermsUrl(_termsUrl);
                        },
                      ),

                      Expanded(
                        child: Text(
                          '이용약관에 동의합니다',

                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          _launchUrl(_termsUrl);
                        },

                        child: const Text('더보기'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 개인정보처리방침 동의
                  Row(
                    children: [
                      Checkbox(
                        value: _privacyAgreed,

                        onChanged: (value) {
                          setState(() {
                            _privacyAgreed = value ?? false;
                          });

                          notifier.setPrivacyAgreed(_privacyAgreed);

                          notifier.setPrivacyUrl(_privacyUrl);
                        },
                      ),

                      Expanded(
                        child: Text(
                          '개인정보처리방침에 동의합니다',

                          style: TextStyle(fontSize: 14, color: textColor),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          _launchUrl(_privacyUrl);
                        },

                        child: const Text('더보기'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),

          child: CustomButton(
            child: const Text('다음'),

            onPressed: () {
              if (formKey.currentState?.validate() != true) return;

              if (!_termsAgreed) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('이용약관에 동의해주세요')));

                return;
              }

              if (!_privacyAgreed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('개인정보처리방침에 동의해주세요')),
                );

                return;
              }

              notifier.setEmailPassword(
                email: emailController.text,

                password: passwordController.text,
              );

              context.push('/signup/profile');
            },
          ),
        ),
      ],
    );
  }
}
