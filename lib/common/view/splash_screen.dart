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
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    ref.listenManual<AuthState>(
      authProvider,
      (previous, next) {
        if (!mounted) return;
        if (next is Authenticated) {
          context.go("/root");
        } else if (next is Unauthenticated) {
          context.go("/login");
        }
      },
    );

    ref.read(authProvider.notifier).checkLoginStatus();
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
