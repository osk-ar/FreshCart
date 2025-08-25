import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/domain/repositories/db_local_repository.dart';
import 'package:supermarket/presentation/blocs/cashier/states/cashier_pagination_state.dart';

class CashierPaginationCubit extends Cubit<CashierPaginationState> {
  final DBLocalRepository _dbLocalRepository;
  CashierPaginationCubit(this._dbLocalRepository)
    : super(CashierFeed(PagingState<int, ProductEntity>()));

  static const _pageLimit = 25;
  String _searchQuery = "";

  PagingState<int, ProductEntity> feedState = PagingState();
  PagingState<int, ProductEntity> searchState = PagingState();

  //* Infinite Scroll Pagination
  Future<void> fetchFeed() async {
    if (state.pagingState.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final newKey = (state.pagingState.keys?.last ?? -1) + 1;
      final newItems = await _dbLocalRepository.getAllProducts(
        _pageLimit,
        newKey * _pageLimit,
      );
      final hasNextPage = newItems.length == _pageLimit;

      final filteredItems = newItems.where((pr) => pr.quantity! > 0).toList();

      if (_stateIsSearch()) return;
      emit(
        state.copyWith(
          pages: [...?state.pagingState.pages, filteredItems],
          keys: [...?state.pagingState.keys, newKey],
          hasNextPage: hasNextPage,
          isLoading: false,
        ),
      );
      feedState = state.pagingState;
    } catch (error) {
      log(error.toString());
      emit(state.copyWith(error: error, isLoading: false));
      feedState = state.pagingState;
    }
  }

  Future<void> fetchSearch() async {
    if (state.pagingState.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final newKey = (state.pagingState.keys?.last ?? -1) + 1;
      final newItems = await _dbLocalRepository.searchProducts(
        _searchQuery,
        itemCount: _pageLimit,
        offset: newKey * _pageLimit,
      );
      final hasNextPage = newItems.length == _pageLimit;

      final filteredItems = newItems.where((pr) => pr.quantity! > 0).toList();

      if (!_stateIsSearch()) return;
      emit(
        state.copyWith(
          pages: [...?state.pagingState.pages, filteredItems],
          keys: [...?state.pagingState.keys, newKey],
          hasNextPage: hasNextPage,
          isLoading: false,
        ),
      );
      searchState = state.pagingState;
    } catch (error) {
      emit(state.copyWith(error: error, isLoading: false));
      feedState = state.pagingState;
    }
  }

  //* Search
  void updateSearchQuery(String query) {
    log("in update search query");
    _searchQuery = query;
    refresh();
  }

  void _resetSearch() {
    _searchQuery = "";
    searchState = PagingState<int, ProductEntity>();
  }

  //* Refresh
  void refresh() {
    switch (state) {
      case CashierFeed():
        _refreshFeed();
        break;
      case CashierSearch():
        _refreshSearch();
        break;
      default:
        log("in unknown refresh state");
    }
  }

  void _refreshSearch() {
    log("in refresh search");
    searchState = PagingState<int, ProductEntity>();
    emit(CashierSearch(searchState));
  }

  void _refreshFeed() {
    log("in refresh feed");
    feedState = PagingState<int, ProductEntity>();
    emit(CashierFeed(feedState));
  }

  //* Helpers
  void switchState() {
    if (_stateIsSearch()) {
      _resetSearch();
      emit(CashierFeed(feedState));
      return;
    }

    emit(CashierSearch(searchState));
  }

  bool _stateIsSearch() {
    return state is CashierSearch;
  }
}
