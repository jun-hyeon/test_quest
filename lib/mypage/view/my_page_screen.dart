import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/common/component/card_tile.dart';
import 'package:test_quest/mypage/widget/circle_network_image.dart';
import 'package:test_quest/user/provider/auth_provider.dart';

class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  // XFile? _selectedImage;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     setState(() {
  //       _selectedImage = image;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    const imageUrl =
        'https://fastly.picsum.photos/id/864/200/200.jpg?hmac=enPW23d2MpTvv2RfL7CtuO_cKSvCg4DGCYtNPc4-48M';
    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleNetworkImage(imageUrl: imageUrl),
                    SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("TestUser123",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.start),
                          SizedBox(height: 4),
                          Text("게임 테스터입니다!",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CardTile(
                    icon: Icons.settings,
                    title: "설정",
                    onTap: () {
                      context.push("/settings");
                    },
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                CardTile(
                  icon: Icons.logout,
                  title: "로그아웃",
                  onTap: () {
                    // 로그아웃 처리
                    ref.read(authProvider.notifier).logout();
                    context.go("/login");
                  },
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
