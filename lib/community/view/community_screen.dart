import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test_quest/community/component/community_card.dart';
import 'package:test_quest/community/model/test_post.dart';
import 'package:test_quest/community/provider/pagination_state.dart';
import 'package:test_quest/community/provider/test_post_pagination_provider.dart';
import 'package:test_quest/schedule/provider/bookmarked_event_provider.dart';
import 'package:test_quest/util/db/app_database.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(scrollListener);
  }

  void scrollListener() {
    final notifier = ref.read(testPostPaginationProvider.notifier);
    final state = ref.read(testPostPaginationProvider);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        state is PaginationData &&
        state.hasNext &&
        !state.isFetching) {
      notifier.fetchMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void onBookmarkPressed(TestPost event) {
    final companion = CalendarEventsCompanion(
      auth: Value(event.author),
      title: Value(event.title),
      description: Value(event.description),
      startDate: Value(event.startDate),
      endDate: Value(event.endDate),
      thumbnailUrl: Value(event.thumbnailUrl),
    );

    ref.read(bookmarkedEventProvider.notifier).addEvent(companion);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testPostPaginationProvider);
    final notifier = ref.read(testPostPaginationProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('글 작성'),
        onPressed: () {
          context.push('/post_create');
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          notifier.refresh();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 첫 번째 SliverAppBar: 제목만 포함하고 스크롤 시 사라짐
            SliverAppBar(
              title: const Text('커뮤니티'),
              centerTitle: true,
              pinned: false, // 고정되지 않음
              floating: true,
              snap: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              expandedHeight: 60,
            ),
            // 두 번째 SliverAppBar: 검색창만 포함하고 고정됨
            SliverAppBar(
              pinned: true, // 고정됨
              floating: false,
              automaticallyImplyLeading: false, // 뒤로가기 버튼 숨김
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              scrolledUnderElevation: 0,
              shape: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 0.5,
                ),
              ),
              flexibleSpace: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: SearchBar(
                    controller: _searchController,
                    hintText: '작성자, 제목, 내용 등으로 검색',
                    onSubmitted: (value) {
                      notifier.setKeyword(value);
                    },
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    leading: const Icon(Icons.search),
                  ),
                ),
              ),
              toolbarHeight: 70, // 검색창의 높이
            ),
            switch (state) {
              PaginationLoading() => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator())),
              PaginationRefreshing() => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator())),
              PaginationData(
                posts: final posts,
                hasNext: final hasNext,
                isFetching: final isFetching
              ) =>
                posts.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text('검색 결과가 없습니다.')))
                    : SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // 실제 게시물 표시
                              if (index < posts.length) {
                                final e = posts[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push("/post_detail", extra: e);
                                  },
                                  child: CommunityCard(
                                    thumbnailUrl: e.thumbnailUrl,
                                    title: e.title,
                                    author: e.author,
                                    startDate: e.startDate,
                                    endDate: e.endDate,
                                    views: e.views,
                                    status: '모집중',
                                    onPressed: () {
                                      onBookmarkPressed(e);
                                    },
                                  ),
                                );
                              }
                              // 로딩 인디케이터 표시
                              else if (isFetching) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              // 마지막 페이지 메시지 표시
                              else if (!hasNext) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(child: Text('마지막 페이지입니다.')),
                                );
                              }
                              // 기본 반환값 (도달하지 않아야 함)
                              return null;
                            },
                            childCount:
                                posts.length + (isFetching || !hasNext ? 1 : 0),
                          ),
                        ),
                      ),
              PaginationError() => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('에러가 발생했습니다.'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => notifier.refresh(),
                          child: const Text('다시 시도'),
                        ),
                      ],
                    ),
                  ),
                ),
            },
          ],
        ),
      ),
    );
  }
}
