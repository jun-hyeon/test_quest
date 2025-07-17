import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/util/service/image_picker_service.dart';
import 'package:test_quest/util/service/permission_service.dart';

class ProfileEditBottomSheet extends ConsumerStatefulWidget {
  const ProfileEditBottomSheet({
    super.key,
    required this.user,
    this.scrollController,
  });

  final UserInfo user;
  final ScrollController? scrollController;

  @override
  ConsumerState<ProfileEditBottomSheet> createState() =>
      _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState
    extends ConsumerState<ProfileEditBottomSheet> {
  XFile? selectedImage;
  late final TextEditingController nicknameController;
  bool _isLoading = false;
  String? _nicknameError;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController(text: widget.user.nickname);
    nicknameController.addListener(_validateNickname);
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  void _validateNickname() {
    final nickname = nicknameController.text.trim();
    setState(() {
      if (nickname.isEmpty) {
        _nicknameError = '닉네임을 입력해주세요';
      } else if (nickname.length < 2) {
        _nicknameError = '닉네임은 2자 이상이어야 합니다';
      } else if (nickname.length > 10) {
        _nicknameError = '닉네임은 10자 이하여야 합니다';
      } else {
        _nicknameError = null;
      }
    });
  }

  bool get _isFormValid =>
      _nicknameError == null && nicknameController.text.trim().isNotEmpty;

  void _pickImage() async {
    final status = await ref.read(permissionProvider).requestPhotoPermission();
    if (!mounted) return;

    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('권한이 거절되었습니다.'),
        ),
      );
      return;
    }

    await ImagePickerService.pickAndSet(
      source: ImageSource.gallery,
      onImagePicked: (image) {
        setState(() {
          selectedImage = image;
        });
      },
    );
  }

  Future<void> _handleSave() async {
    if (!_isFormValid || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(userNotifierProvider.notifier).updateUser(
            (user) => user.copyWith(
              nickname: nicknameController.text.trim(),
              profileImg: selectedImage != null
                  ? File(selectedImage!.path).path
                  : user.profileImg,
            ),
          );

      if (!mounted) return;
      _showSuccessAndClose();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessAndClose() {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    HapticFeedback.lightImpact();
    navigator.pop();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '프로필이 성공적으로 업데이트되었습니다!',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showErrorDialog(dynamic error) {
    HapticFeedback.heavyImpact();

    final errorMessage = _getErrorMessage(error);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: 40,
        ),
        title: const Text('저장 실패'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(errorMessage),
            const SizedBox(height: 12),
            Text(
              '문제가 지속되면 잠시 후 다시 시도해주세요.',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              Future.delayed(const Duration(milliseconds: 300), _handleSave);
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('network') || errorStr.contains('connection')) {
      return '네트워크 연결을 확인해주세요.';
    } else if (errorStr.contains('timeout')) {
      return '서버 응답이 지연되고 있습니다.';
    } else if (errorStr.contains('401') || errorStr.contains('unauthorized')) {
      return '로그인이 만료되었습니다. 다시 로그인해주세요.';
    } else if (errorStr.contains('닉네임') || errorStr.contains('nickname')) {
      return '이미 사용중인 닉네임입니다.';
    } else {
      return '프로필 업데이트 중 오류가 발생했습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      '프로필 편집',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close_outlined),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickImage,
              child: ProfilePicker(selectedImage: selectedImage),
            ),
            const SizedBox(height: 16),
            CustomTextfield(
              controller: nicknameController,
              obscure: false,
              hintText: '닉네임을 입력하세요',
              errorText: _nicknameError,
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: (!_isFormValid || _isLoading) ? null : _handleSave,
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('저장 중...', style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
