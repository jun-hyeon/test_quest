import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/common/component/card_tile.dart';
import 'package:test_quest/common/component/custom_button.dart';
import 'package:test_quest/common/component/custom_textfield.dart';
import 'package:test_quest/common/component/profile_picker.dart';
import 'package:test_quest/mypage/widget/circle_network_image.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/provider/user_provider.dart';
import 'package:test_quest/util/service/image_picker_service.dart';
import 'package:test_quest/util/service/permission_service.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('사용자 정보가 없습니다.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleNetworkImage(
                      imageUrl: user.profileImg ?? "",
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            user.nickname,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CardTile(
                  icon: Icons.person_outline_outlined,
                  title: '프로필 편집',
                  onTap: () {
                    _showProfileEditBottomSheet(context, ref, user);
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                CardTile(
                  icon: Icons.settings,
                  title: "설정",
                  onTap: () {
                    context.push("/settings");
                  },
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                CardTile(
                  icon: Icons.logout,
                  title: "로그아웃",
                  onTap: () {
                    // 로그아웃 처리 - Router Provider가 자동으로 로그인 화면으로 리다이렉션
                    ref.read(authProvider.notifier).logout();
                  },
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                '사용자 정보 로드 실패',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(userNotifierProvider.notifier).refresh();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProfileEditBottomSheet(
      BuildContext context, WidgetRef ref, UserInfo user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, // 초기 높이 (화면의 60%)
        minChildSize: 0.4, // 최소 높이
        maxChildSize: 0.9, // 최대 높이
        expand: false,
        builder: (context, scrollController) => ProfileEditBottomSheet(
          context: context,
          ref: ref,
          user: user,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class ProfileEditBottomSheet extends ConsumerStatefulWidget {
  const ProfileEditBottomSheet({
    super.key,
    required this.context,
    required this.ref,
    required this.user,
    this.scrollController,
  });

  final BuildContext context;
  final WidgetRef ref;
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
  bool _isLoading = false; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    // 초기값으로 현재 닉네임 설정
    nicknameController = TextEditingController(text: widget.user.nickname);
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final status = await ref.read(permissionProvider).requestPhotoPermission();
    if (!mounted) return;
    if (!status.isGranted) {
      // 조건 수정 (!status.isGranted)
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
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.close_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              child: ProfilePicker(selectedImage: selectedImage),
              onTap: () {
                _pickImage();
              },
            ),
            const SizedBox(height: 16),
            CustomTextfield(
              controller: nicknameController,
              obscure: false,
              hintText: '닉네임을 입력하세요',
            ),
            const SizedBox(height: 32),
            CustomButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      // 로딩 중이면 비활성화
                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await ref
                            .read(userNotifierProvider.notifier)
                            .updateUser(
                              (user) => user.copyWith(
                                nickname: nicknameController.text.trim(),
                                profileImg: selectedImage != null
                                    ? File(selectedImage!.path).path
                                    : user.profileImg, // 기존 이미지 유지
                              ),
                            );

                        if (mounted) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('프로필이 성공적으로 업데이트되었습니다.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('업데이트 실패: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
