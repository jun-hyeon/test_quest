import 'package:go_router/go_router.dart';
import 'package:test_quest/common/view/root_tab.dart';
import 'package:test_quest/common/view/splash_screen.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/view/post_detail_screen.dart';
import 'package:test_quest/settings/view/settings_view.dart';
import 'package:test_quest/user/view/login_screen.dart';
import 'package:test_quest/user/view/sign_up_screen.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUpScreen()),
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
          //추후 id로 바꿀 것
          final post = state.extra as TestPost;
          return PostDetailScreen(post: post);
        })
  ],
);
