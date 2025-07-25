import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_quest/route/router.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';
import 'package:test_quest/theme/theme_data.dart';
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
    // Router Provider 사용 - Auth State에 따른 자동 리다이렉션
    final routerConfig = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Test Quest',
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(themeModeProvider),
      theme: lightTheme,
      darkTheme: darkTheme,
      routerConfig: routerConfig,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
      ],
    );
  }
}
