import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/auth/provider/auth_state.dart';
import 'package:test_quest/auth/view/login_screen.dart';
import 'package:test_quest/auth/view/profile_signup_screen.dart';
import 'package:test_quest/auth/view/sign_up_screen.dart';
import 'package:test_quest/common/view/root_tab.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/view/post_create_screen.dart';
import 'package:test_quest/community/view/post_detail_screen.dart';
import 'package:test_quest/settings/view/settings_view.dart';

/// Firebase Auth 상태 변화를 감지하는 Router Notifier
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  late final ProviderSubscription _subscription;

  RouterNotifier(this._ref) {
    // Firebase Auth 상태 변화를 감지
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
    initialLocation: '/login', // '/splash'에서 '/login'으로 변경
    refreshListenable: routerNotifier, // Auth State 변화 감지
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final currentUser = FirebaseAuth.instance.currentUser;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToSignup = state.matchedLocation.startsWith('/signup');

      log(
        'Redirect 체크 - 경로: ${state.matchedLocation}, 인증: $authState, currentUser: ${currentUser?.uid}',
        name: 'Router.redirect',
      );

      // 로그인, 회원가입은 항상 허용
      if (isGoingToLogin || isGoingToSignup) {
        return null;
      }

      // Firebase Auth currentUser가 없으면 로그인으로 리다이렉션
      if (currentUser == null) {
        log(
          'Firebase Auth currentUser 없음 → 로그인 화면',
          name: 'Router.redirect',
        );
        return '/login';
      }

      // 인증된 상태에서 로그인 페이지 접근 시 메인 화면으로
      if (isGoingToLogin) {
        return '/root';
      }

      // 그 외의 경우는 그대로 진행
      return null;
    },
    routes: [
      // SplashScreen 라우트 제거
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
            final postId = state.extra as String;
            return PostDetailScreen(postId: postId);
          }),
      GoRoute(
        path: '/post_create',
        builder: (context, state) =>
            const PostCreateScreen(mode: PostFormMode.create, post: null),
      ),
      GoRoute(
        path: '/post_edit',
        builder: (context, state) {
          final post = state.extra as TestPost;
          return PostCreateScreen(mode: PostFormMode.edit, post: post);
        },
      ),
    ],
  );
});
