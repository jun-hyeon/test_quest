import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/common/const.dart';
import 'package:test_quest/community/component/community_card.dart';
import 'package:test_quest/community/model/test_post.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyPosts = <TestPost>[
      TestPost(
        id: "1",
        title: '에덴 서약 CBT 모집!',
        description: '신작 MMORPG “에덴 서약”의 클로즈 베타 테스트 참가자를 모집합니다.',
        startDate: DateTime.now().add(const Duration(days: 3)),
        endDate: DateTime.now().add(const Duration(days: 10)),
        platform: TestPlatform.pc,
        type: TestType.cbt,
        thumbnailUrl: 'https://picsum.photos/400',
        linkUrl: 'https://example.com/eden',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TestPost(
        id: "2",
        title: '마법 대전 알파테스트 시작',
        description: '“마법 대전”이 곧 알파 테스트에 돌입합니다. 선착순 1,000명!',
        startDate: DateTime.now().add(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 5)),
        platform: TestPlatform.mobile,
        type: TestType.alpha,
        thumbnailUrl: 'https://picsum.photos/400',
        linkUrl: 'https://example.com/magic',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TestPost(
        id: "3",
        title: 'FPS 신작 “샤프슛” OBT 사전 등록!',
        description: '고사양 그래픽 FPS “샤프슛”의 오픈 베타 테스트에 참여하세요.',
        startDate: DateTime.now().add(const Duration(days: 5)),
        endDate: DateTime.now().add(const Duration(days: 12)),
        platform: TestPlatform.console,
        type: TestType.obt,
        thumbnailUrl: 'https://picsum.photos/400',
        linkUrl: 'https://example.com/sharpshoot',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TestPost(
        id: "4",
        title: '전략 게임 “제국의 부름” CBT 안내',
        description: '전략 시뮬레이션의 진수를 보여줄 “제국의 부름” CBT 정보입니다.',
        startDate: DateTime.now().add(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 8)),
        platform: TestPlatform.mobile,
        type: TestType.cbt,
        thumbnailUrl: 'https://picsum.photos/400',
        linkUrl: 'https://example.com/empire',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('글 작성'),
        onPressed: () {
          context.push('/post_create');
        },
      ),
      appBar: AppBar(
        title: const Text('조회'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: dummyPosts
            .map((e) => GestureDetector(
                  onTap: () {
                    context.push("/post_detail", extra: e);
                  },
                  child: CommunityCard(
                    thumbnailUrl: e.thumbnailUrl,
                    title: e.title,
                    author: "asdf",
                    startDate: formatToYMD(e.startDate),
                    endDate: formatToYMD(e.endDate),
                    views: 100,
                    status: '모집중',
                  ),
                ))
            .toList(),
        // children: const [
        //   CommunityCard(
        //     thumbnailUrl: 'https://picsum.photos/400',
        //     title: '커뮤니티 게시글 1',
        //     author: '작성자 A',
        //     startDate: '2024-06-01',
        //     endDate: '2024-06-10',
        //     views: 123,
        //     status: '모집중',
        //   ),
        //   CommunityCard(
        //     thumbnailUrl: 'https://picsum.photos/400',
        //     title: '커뮤니티 게시글 2',
        //     author: '작성자 B',
        //     startDate: '2024-06-05',
        //     endDate: '2024-06-15',
        //     views: 456,
        //     status: '모집완료',
        //   ),
        //   CommunityCard(
        //     thumbnailUrl: 'https://picsum.photos/400',
        //     title: '커뮤니티 게시글 3',
        //     author: '작성자 C',
        //     startDate: '2024-06-10',
        //     endDate: '2024-06-20',
        //     views: 789,
        //     status: '모집중',
        //   ),
        // ],
      ),
    );
  }
}
