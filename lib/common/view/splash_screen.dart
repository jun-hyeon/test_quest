import 'dart:async';
import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/auth/provider/auth_state.dart';

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
    log('[SplashScreen] 스플래시 화면 시작');
    await Future.delayed(const Duration(milliseconds: 3000));

    log('[SplashScreen] 인증 상태 확인 시작');

    // Auth State 변화를 listen
    ref.listenManual<AuthState>(authProvider, (previous, next) {
      log('[SplashScreen] Auth State 변화: $previous → $next');
      if (!mounted || _isNavigating) return;

      _isNavigating = true;
      if (next is Authenticated) {
        log('[SplashScreen] 인증됨 → 메인 화면으로 이동');
        context.go('/root');
      } else if (next is Unauthenticated) {
        log('[SplashScreen] 인증안됨 → 로그인 화면으로 이동');
        context.go('/login');
      }
    });

    // Firebase Auth는 자동으로 상태를 관리하므로 별도 확인 불필요
    log('[SplashScreen] Firebase Auth 자동 상태 관리');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/test_quest_logo.png', height: 300),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'TestQuest',
                  textStyle:
                      textTheme.displayMedium?.copyWith(
                        fontFamily: GoogleFonts.pressStart2p().fontFamily,
                        color: colorScheme.onSurface,
                      ) ??
                      GoogleFonts.pressStart2p(fontSize: 30),
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                setState(() {
                  _showSubtitle = true;
                });
              },
            ),
            const SizedBox(height: 8),
            Visibility(
              visible: _showSubtitle,
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '게임 테스트 정보의 모든 것',
                    textStyle:
                        textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ) ??
                        const TextStyle(fontSize: 16),
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
