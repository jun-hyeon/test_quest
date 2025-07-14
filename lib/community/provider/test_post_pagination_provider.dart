import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_quest/community/model/test_post_pagination.dart';
import 'package:test_quest/community/provider/pagination_state.dart';
import 'package:test_quest/community/repository/test_post_repository_impl.dart';

import '../model/test_post.dart';

final testPostPaginationProvider =
    NotifierProvider<TestPostPaginationNotifier, PaginationState>(() {
  return TestPostPaginationNotifier();
});

class TestPostPaginationNotifier extends Notifier<PaginationState> {
  late final repository = ref.read(testPostRepositoryProvider);
  final List<TestPost> _posts = [];
  bool _hasNext = true;
  bool _isFetching = false;
  String? _lastId;
  DateTime? _lastCreateAt;

  int _pageSize = 6;
  String _sortOrder = 'latest';
  String _keyword = '';

  int _retryCount = 0;
  final int _maxRetries = 3;

  @override
  PaginationState build() {
    _init();
    return const PaginationLoading();
  }

  Future<void> _init() async {
    state = const PaginationLoading();
    _posts.clear();
    _hasNext = true;
    _lastId = null;
    _lastCreateAt = null;

    try {
      final result = await _fetchPosts(
        pageSize: _pageSize,
        sortOrder: _sortOrder,
        keyword: _keyword,
      );

      _posts.addAll(result.gameBoards);
      _hasNext = result.hasNext;

      if (_posts.isNotEmpty) {
        _lastId = _posts.last.id;
        _lastCreateAt = _posts.last.createdAt;
        log('[LastItemInfo] $_lastId, $_lastCreateAt');
      }

      state = PaginationData(
        posts: List.unmodifiable(_posts),
        hasNext: _hasNext,
        isFetching: false,
      );
      _retryCount = 0;
    } catch (error, stackTrace) {
      log('Pagination error during init: $error\n$stackTrace');
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 2));
        _init();
      } else {
        state = PaginationError(error, stackTrace);
      }
    }
  }

  Future<void> fetchMore() async {
    if (!_hasNext || _isFetching) return;
    _isFetching = true;

    try {
      final result = await _fetchPosts(
        lastId: _lastId,
        lastCreateAt: _lastCreateAt,
        pageSize: _pageSize,
        sortOrder: _sortOrder,
        keyword: _keyword,
      );

      _posts.addAll(result.gameBoards);
      _hasNext = result.hasNext;

      if (_posts.isNotEmpty) {
        _lastId = _posts.last.id;
        _lastCreateAt = _posts.last.createdAt;
        log('[LastItemInfo] $_lastId, $_lastCreateAt');
      }

      state = PaginationData(
        posts: List.unmodifiable(_posts),
        hasNext: _hasNext,
        isFetching: false,
      );
    } on DioException catch (error, stackTrace) {
      log('Pagination DioException during fetchMore: ${error.response?.statusCode}');

      if (error.response?.statusCode == 401) {
        log('[fetchMore] 401 detected, retrying after token refresh...');
        try {
          final result = await _fetchPosts(
            lastId: _lastId,
            lastCreateAt: _lastCreateAt,
            pageSize: _pageSize,
            sortOrder: _sortOrder,
            keyword: _keyword,
          );

          _posts.addAll(result.gameBoards);
          _hasNext = result.hasNext;

          if (_posts.isNotEmpty) {
            _lastId = _posts.last.id;
            _lastCreateAt = _posts.last.createdAt;
            log('[LastItemInfo] $_lastId, $_lastCreateAt');
          }

          state = PaginationData(
            posts: List.unmodifiable(_posts),
            hasNext: _hasNext,
            isFetching: false,
          );
        } catch (e, st) {
          log('Pagination fetchMore retry failed: $e\n$st');
          state = PaginationError(e, st);
        }
      } else {
        log('Pagination error during fetchMore: $error\n$stackTrace');
        state = PaginationError(error, stackTrace);
      }
    } finally {
      _isFetching = false;
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is PaginationData) {
      state = PaginationRefreshing(current.posts);
    } else {
      state = const PaginationLoading();
    }
    await _init();
  }

  void setPageSize(int size) {
    _pageSize = size;
    refresh();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    refresh();
  }

  void setKeyword(String keyword) {
    _keyword = keyword;
    refresh();
  }

  Future<TestPostPagination> _fetchPosts({
    String? lastId,
    DateTime? lastCreateAt,
    int pageSize = 5,
    String sortOrder = 'latest',
    String keyword = '',
  }) {
    return repository.fetchPosts(
      lastId: lastId,
      lastCreateAt: lastCreateAt,
      pageSize: pageSize,
      sortOrder: sortOrder,
      keyword: keyword,
    );
  }
}
