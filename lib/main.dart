import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_quest/firebase_options.dart';
import 'package:test_quest/route/router.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';
import 'package:test_quest/theme/theme_data.dart';
import 'package:test_quest/util/service/fcm_service.dart';
import 'package:test_quest/util/service/notification_service.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 필수 초기화 작업
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('ko_KR');
  timeago.setLocaleMessages('ko', timeago.KoMessages());
  try {
    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final container = ProviderContainer();

    // 알림 서비스 초기화
    final notificationService = container.read(notiProvider);
    await notificationService.initNotification();

    // FCM 서비스 초기화
    final fcmService = container.read(fcmServiceProvider);
    await fcmService.initialize();

    try {
      await fcmService.subscribeToNewPostNotifications();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      log('FCM 토큰: $fcmToken');
    } catch (e) {
      log('FCM 구독 중 오류: $e');
    }
    container.dispose();
  } catch (e) {
    log('Firebase 초기화 중 오류: $e');
  }

  // 앱 실행
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Firebase Auth는 자동으로 상태를 관리하므로 별도 확인 불필요
    log('[MyApp] Firebase Auth 자동 상태 관리');
  }

  @override
  Widget build(BuildContext context) {
    // Router Provider 사용 - Auth State에 따른 자동 리다이렉션
    final routerConfig = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Test Quest',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: routerConfig,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', '')],
    );
  }
}
