import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/common/component/testquest_snackbar.dart';
import 'package:test_quest/settings/provider/theme_provider.dart';
import 'package:test_quest/util/service/permission_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isDeleting = false;
  PermissionStatus _notificationStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  /// 알림 권한 상태 확인
  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text(
              _getNotificationStatusText(_notificationStatus),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            value: _notificationStatus.isGranted,
            onChanged: (value) async {
              if (value) {
                await _requestNotificationPermission();
              } else {
                _showNotificationSettingsDialog(context);
              }
            },
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
            leading: Icon(
              Icons.delete_forever,
              color: _isDeleting ? Colors.grey : Colors.red,
            ),
            title: Text(
              '회원 탈퇴',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _isDeleting ? Colors.grey : Colors.red,
                  ),
            ),
            subtitle: _isDeleting
                ? const Text('처리 중...')
                : const Text('계정을 영구적으로 삭제합니다'),
            onTap:
                _isDeleting ? null : () => _showAccountDeletionDialog(context),
          ),
        ],
      ),
    );
  }

  /// 알림 권한 요청
  Future<void> _requestNotificationPermission() async {
    try {
      final permissionService = ref.read(permissionProvider);
      final status = await permissionService.requestNotificationPermission();

      setState(() {
        _notificationStatus = status;
      });

      if (status.isGranted) {
        if (mounted) {
          TestQuestSnackbar.show(
            context,
            '알림이 활성화되었습니다.',
            isError: false,
          );
        }
      } else if (status.isPermanentlyDenied) {
        if (mounted) {
          _showNotificationSettingsDialog(context);
        }
      }
    } catch (e) {
      if (mounted) {
        TestQuestSnackbar.show(
          context,
          '알림 권한 요청에 실패했습니다.',
          isError: true,
        );
      }
    }
  }

  /// 알림 권한 상태에 따른 텍스트 반환
  String _getNotificationStatusText(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => '알림이 활성화되어 있습니다',
      PermissionStatus.denied => '알림이 비활성화되어 있습니다',
      PermissionStatus.permanentlyDenied => '시스템 설정에서 알림을 활성화해주세요',
      PermissionStatus.restricted => '알림 권한이 제한되어 있습니다',
      PermissionStatus.limited => '알림 권한이 제한적으로 허용되어 있습니다',
      PermissionStatus.provisional => '알림 권한이 임시로 허용되어 있습니다',
    };
  }

  /// 알림 설정 다이얼로그 표시
  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림 설정'),
        content: const Text('알림을 비활성화하려면 시스템 설정에서 변경해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('설정으로 이동'),
          ),
        ],
      ),
    );
  }

  /// 회원탈퇴 확인 다이얼로그 표시
  void _showAccountDeletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text(
          '정말로 회원을 탈퇴하시겠습니까?\n\n'
          '• 모든 데이터가 영구적으로 삭제됩니다\n'
          '• 복구할 수 없습니다\n'
          '• 작성한 게시글도 모두 삭제됩니다',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('탈퇴하기'),
          ),
        ],
      ),
    );
  }

  /// 회원탈퇴 실행
  Future<void> _deleteAccount() async {
    setState(() => _isDeleting = true);

    try {
      // userProvider를 통해 계정 삭제
      await ref.read(authProvider.notifier).deleteAccount();

      // 성공 시 로그아웃 처리
      await ref.read(authProvider.notifier).logout();

      if (mounted) {
        TestQuestSnackbar.show(
          context,
          '회원탈퇴가 완료되었습니다.',
          isError: false,
        );
      }
    } catch (e) {
      if (mounted) {
        TestQuestSnackbar.show(
          context,
          '회원탈퇴에 실패했습니다: ${e.toString()}',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }
}
