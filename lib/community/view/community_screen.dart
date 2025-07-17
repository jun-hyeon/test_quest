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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                notifier.setKeyword(value);
              },
              decoration: const InputDecoration(
                hintText: '게임명, 개발사 등으로 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: switch (state) {
              PaginationLoading() =>
                const Center(child: CircularProgressIndicator()),
              PaginationRefreshing() =>
                const Center(child: CircularProgressIndicator()),
              PaginationData(
                posts: final posts,
                hasNext: final hasNext,
                isFetching: final isFetching
              ) =>
                posts.isEmpty
                    ? const Center(child: Text('검색 결과가 없습니다.'))
                    : RefreshIndicator(
                        onRefresh: () => notifier.refresh(),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8),
                          itemCount: posts.length +
                              (isFetching ? 1 : 0) +
                              (hasNext ? 0 : 1),
                          itemBuilder: (context, index) {
                            if (index >= posts.length + (isFetching ? 0 : 0)) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(child: Text('마지막 페이지입니다.')),
                              );
                            }
                            if (index >= posts.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
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
                          },
                        ),
                      ),
              PaginationError() => Center(
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
            },
          ),
        ],
      ),
    );
  }
}
