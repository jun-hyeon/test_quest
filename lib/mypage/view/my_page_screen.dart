import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/auth/provider/auth_provider.dart';
import 'package:test_quest/common/component/card_tile.dart';
import 'package:test_quest/mypage/widget/profile_edit_bottom_sheet.dart';
import 'package:test_quest/user/model/user_info.dart';
import 'package:test_quest/user/provider/user_provider.dart';

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
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: user.profileUrl ?? "",
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 50,
                      ),
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return const Icon(Icons.person);
                      },
                    ),
                    // CircleNetworkImage(
                    //   imageUrl: user.profileUrl ?? "",
                    // ),
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
                  onTap: () => _showProfileEditBottomSheet(context, user),
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

  void _showProfileEditBottomSheet(BuildContext context, UserInfo user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6, // 초기 높이 (화면의 60%)
        minChildSize: 0.4, // 최소 높이
        maxChildSize: 0.9, // 최대 높이
        expand: false,
        builder: (context, scrollController) => ProfileEditBottomSheet(
          user: user,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
