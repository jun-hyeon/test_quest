import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_quest/user/provider/auth_provider.dart';
import 'package:test_quest/user/provider/auth_state.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _showSubtitle = false;
  bool _isNavigating = false; // 중복 네비게이션 방지

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    print('[SplashScreen] 스플래시 화면 시작');
    await Future.delayed(const Duration(milliseconds: 3000));

    print('[SplashScreen] 인증 상태 확인 시작');

    // Auth State 변화를 listen
    ref.listenManual<AuthState>(
      authProvider,
      (previous, next) {
        print('[SplashScreen] Auth State 변화: $previous → $next');
        if (!mounted || _isNavigating) return;

        _isNavigating = true;
        if (next is Authenticated) {
          print('[SplashScreen] 인증됨 → 메인 화면으로 이동');
          context.go('/root');
        } else if (next is Unauthenticated) {
          print('[SplashScreen] 인증안됨 → 로그인 화면으로 이동');
          context.go('/login');
        }
      },
    );

    // 인증 상태 확인
    await ref.read(authProvider.notifier).checkLoginStatus();
    print('[SplashScreen] 인증 상태 확인 완료');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/test_quest_logo.png',
              height: 300,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'TestQuest',
                  textStyle: GoogleFonts.pressStart2p(
                    fontSize: 30,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                setState(() {
                  _showSubtitle = true;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Visibility(
              visible: _showSubtitle,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '게임 테스트 정보의 모든 것',
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
