import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '설정',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SwitchListTile(
            title: Text(
              '알림 설정',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text(
              isDarkMode ? '라이트 테마' : '다크 테마',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              '프로필 수정',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // TODO: navigate to profile edit screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever),
            title: Text(
              '회원 탈퇴',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () {
              // TODO: show confirmation and handle account deletion
            },
          ),
        ],
      ),
    );
  }
}
