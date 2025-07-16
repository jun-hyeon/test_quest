import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/common/view/root_tab.dart';
import 'package:test_quest/common/view/splash_screen.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/view/post_create_screen.dart';
import 'package:test_quest/community/view/post_detail_screen.dart';
import 'package:test_quest/settings/view/settings_view.dart';
import 'package:test_quest/user/provider/auth_provider.dart';
import 'package:test_quest/user/provider/auth_state.dart';
import 'package:test_quest/user/view/login_screen.dart';
import 'package:test_quest/user/view/profile_signup_screen.dart';
import 'package:test_quest/user/view/sign_up_screen.dart';

/// Auth State 변화를 감지하는 Router Notifier
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription _subscription;

  RouterNotifier(this._ref) {
    // Auth Provider 상태 변화를 감지
    _subscription = _ref.listen<AuthState>(
      authProvider,
      (_, next) {
        log(
          'Auth State 변화 감지: $next',
          name: 'RouterNotifier',
        );
        notifyListeners(); // Router에게 상태 변화 알림
      },
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

/// Router Provider - Auth State에 따른 자동 리다이렉션 제공
final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: routerNotifier, // Auth State 변화 감지
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation.startsWith('/signup');
      final isGoingToSplash = state.matchedLocation == '/splash';

      log(
        'Redirect 체크 - 경로: ${state.matchedLocation}, 인증: $authState',
        name: 'Router.redirect',
      );

      // 스플래시, 로그인, 회원가입은 항상 허용 (스플래시에서 직접 네비게이션 처리)
      if (isGoingToSplash || isGoingToLogin || isGoingToSignup) {
        return null;
      }

      // 인증되지 않은 상태에서 보호된 페이지 접근 시 로그인으로
      if (authState is! Authenticated) {
        log(
          '보호된 페이지 접근 차단 → 로그인 화면',
          name: 'Router.redirect',
        );
        return '/login';
      }

      // 그 외의 경우는 그대로 진행
      return null;
    },
    routes: [
      GoRoute(
          path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const SignupProfileScreen(),
          )
        ],
      ),
      GoRoute(
        path: '/root',
        builder: (context, state) => const RootTab(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
          path: '/post_detail',
          builder: (context, state) {
            final post = state.extra as TestPost;
            return PostDetailScreen(post: post);
          }),
      GoRoute(
        path: '/post_create',
        builder: (context, state) => const PostCreateScreen(),
      ),
    ],
  );
});
