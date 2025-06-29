import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_quest/common/view/root_tab.dart';
import 'package:test_quest/common/view/splash_screen.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';
import 'package:test_quest/settings/view/settings_view.dart';
import 'package:test_quest/theme/theme_data.dart';
import 'package:test_quest/user/view/login_screen.dart';
import 'package:test_quest/user/view/profile_signup_screen.dart';
import 'package:test_quest/user/view/sign_up_screen.dart';
import 'package:test_quest/util/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await initializeDateFormatting('ko_KR');
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Quest',
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeModeProvider),
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        'signup/profile': (context) => const ProfileSignupScreen(),
        '/root': (context) => const RootTab(),
        '/settings': (context) => const SettingsScreen(),

        // Add other routes here if needed
      },
      home: const SplashScreen(),
    );
  }
}
