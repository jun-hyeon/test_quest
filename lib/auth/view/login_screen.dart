import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/auth/provider/auth_state.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';
import 'package:test_quest/util/service/permission_service.dart';
import 'package:test_quest/util/validator.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      _permissionRequest();
    });

    _emailController.addListener(() {
      ref.read(authProvider.notifier).updateEmail(_emailController.text);
    });

    _passwordController.addListener(() {
      ref.read(authProvider.notifier).updatePassword(_passwordController.text);
    });
    _listenAuthState();
  }

  @override
  void dispose() {
    _emailController.removeListener(() {});
    _passwordController.removeListener(() {});
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.reset(); // Reset the form state

    super.dispose();
  }

  void _permissionRequest() async {
    if (!mounted) return;

    if (Platform.isIOS) {
      await ref.read(permissionProvider).requestTrackingPermission();
    }

    if (!mounted) return;
    await ref.read(permissionProvider).requestNotificationPermission();
  }

  void _listenAuthState() {
    ref.listenManual<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;
      if (next is Authenticated) {
        TestQuestSnackbar.show(context, '로그인에 성공했습니다.');

        context.go("/root");
      }
    });
  }

  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();

    final auth = ref.read(authProvider.notifier);
    await auth.login();

    final currentState = ref.read(authProvider);

    if (!mounted) return;
    if (currentState is AuthFormInvalid) {
      TestQuestSnackbar.show(context, '로그인 정보를 확인해주세요.', isError: true);
    } else if (currentState is Unauthenticated &&
        currentState.errorMessage != null) {
      // 로그인 실패 시 스낵바 표시
      TestQuestSnackbar.show(context, '로그인에 실패했습니다.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final currentThemeMode = ref.watch(themeModeProvider); // 현재 테마 모드 감지

    // 테마 모드에 따라 로고 이미지 경로 선택
    final String googleLogoAssetPath = currentThemeMode == ThemeMode.dark
        ? 'assets/icons/google/svg/dark/ios_dark_sq_na.svg'
        : 'assets/icons/google/svg/neutral/ios_neutral_sq_na.svg';
    final authState = ref.watch(authProvider);

    if (authState is AuthLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String? emailError;
    String? passwordError;

    if (authState is Unauthenticated) {
      emailError = authState.errorMessage;
    }

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/test_quest_logo.png',
                height: 200,
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "TestQuest",
                style: textTheme.displayMedium?.copyWith(
                  fontFamily: GoogleFonts.pressStart2p().fontFamily,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "게임 테스터를 위한 테스트 일정 관리 앱",
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            // 이메일 필드
            CustomTextfield(
              obscure: false,
              controller: _emailController,
              labelText: "이메일",
              prefixIcon: Icons.email_outlined,
              validator: Validator.validateEmail,
              errorText: null,
            ),
            const SizedBox(height: 24),

            // 비밀번호 필드
            CustomTextfield(
              obscure: true,
              controller: _passwordController,
              labelText: "비밀번호",
              prefixIcon: Icons.lock_outline,
              validator: Validator.validatePassword,
              errorText: null,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  child: const Text("회원가입"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 로그인 버튼
            CustomButton(
              child: const Text('로그인'),
              onPressed: () async => await _handleLogin(),
            ),
            const SizedBox(height: 24),

            // 구분선
            Row(
              children: [
                Expanded(child: Divider(color: colorScheme.outlineVariant)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "또는",
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: colorScheme.outlineVariant)),
              ],
            ),
            const SizedBox(height: 24),

            // 개선된 Google 로그인 버튼
            _googleSignInButton(currentThemeMode, googleLogoAssetPath),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _googleSignInButton(
    ThemeMode currentThemeMode,
    String googleLogoAssetPath,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () async {
          print("Google 로그인 버튼 클릭됨 ");
          // ... 로그인 로직 ...
          await ref.read(authProvider.notifier).signInWithGoogle();
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: currentThemeMode == ThemeMode.dark
              ? const Color(0xFF131314)
              : Colors.white,
          side: BorderSide(
            color: currentThemeMode == ThemeMode.dark
                ? const Color(0xFF8E918F)
                : const Color(0xFF747775),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SvgPicture.asset(googleLogoAssetPath, height: 24),
            ),
            Text(
              'Google 계정으로 로그인',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: currentThemeMode == ThemeMode.dark
                    ? const Color(0xFFE3E3E3)
                    : const Color(0xFF1F1F1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
