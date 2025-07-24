import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/core/services/image_service.dart';
import 'package:supermarket/domain/entities/product_batch_entity.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/domain/repositories/db_local_repository.dart';
import 'package:supermarket/presentation/blocs/inventory/states/inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final DBLocalRepository _dbLocalRepository;
  final ImageService _imageService;

  InventoryCubit(this._dbLocalRepository, this._imageService)
    : super(InventoryFeed(PagingState<int, ProductEntity>()));

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

      if (_stateIsSearch()) return;
      emit(
        state.copyWith(
          pages: [...?state.pagingState.pages, newItems],
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

      if (!_stateIsSearch()) return;
      emit(
        state.copyWith(
          pages: [...?state.pagingState.pages, newItems],
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
    log("in refresh");
    switch (state) {
      case InventoryFeed():
        _refreshFeed();
        break;
      case InventorySearch():
        _refreshSearch();
        break;
      default:
        log("in unknown state");
    }
  }

  void _refreshSearch() {
    log("in refresh search");
    searchState = PagingState<int, ProductEntity>();
    emit(InventorySearch(searchState));
  }

  void _refreshFeed() {
    log("in refresh feed");
    feedState = PagingState<int, ProductEntity>();
    emit(InventoryFeed(feedState));
  }

  //* CUD Operations
  Future<void> addProduct(ProductEntity product) async {
    try {
      await _dbLocalRepository.addProduct(product);
      _updateUiAfterModifyingList(product, _addToLastPage);
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: e));
    }
  }

  Future<void> removeProduct(ProductEntity product) async {
    try {
      await _dbLocalRepository.removeProduct(product.id!);
      if (product.imagePath != null) {
        await _imageService.deleteImage(product.imagePath!);
      }

      _updateUiAfterModifyingList(product, _removeFromList);
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: e));
    }
  }

  Future<void> updateProduct(ProductEntity product) async {
    try {
      final oldProduct = await _dbLocalRepository.getProductById(product.id!);
      if (oldProduct!.imagePath != null) {
        await _imageService.deleteImage(oldProduct.imagePath);
      }

      await _dbLocalRepository.updateProduct(product);
      _updateUiAfterModifyingList(product, _updateItemInList);
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: e));
    }
  }

  Future<void> restockProduct(ProductBatchEntity batch) async {
    try {
      await _dbLocalRepository.restockProduct(batch);
      final product = await _dbLocalRepository.getProductById(batch.productId!);
      _updateUiAfterModifyingList(product!, _updateItemInList);
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(error: e));
    }
  }

  //* CUD Helpers
  void _updateUiAfterModifyingList(
    ProductEntity product,
    PagingState<int, ProductEntity> Function(
      ProductEntity product,
      PagingState<int, ProductEntity> currentPagingState,
    )
    action,
  ) {
    if (state is InventorySearch) {
      refresh();
    } else {
      final PagingState<int, ProductEntity> newState = action(
        product,
        state.pagingState,
      );
      emit(state.copyWith(pages: newState.pages, keys: newState.keys));
    }
  }

  PagingState<int, ProductEntity> _addToLastPage(
    ProductEntity product,
    PagingState<int, ProductEntity> currentPagingState,
  ) {
    final hasNextPage = currentPagingState.hasNextPage;
    final pages = currentPagingState.pages;
    final keys = currentPagingState.keys;
    final lastPageFull = pages?.last.length == _pageLimit;

    if (hasNextPage) return currentPagingState;

    late final List<List<ProductEntity>> newPages;
    List<ProductEntity> newPage = [];
    List<int> newKeys = [...keys ?? []];

    if (lastPageFull) {
      newPage = [product];
      newPages = [...?pages, newPage];
      newKeys.add(keys!.last + 1);
    } else {
      newPage = [...?pages?.last, product];
      newPages =
          pages?.map((page) => page == pages.last ? newPage : page).toList() ??
          [];
    }

    return currentPagingState.copyWith(pages: newPages, keys: newKeys);
  }

  PagingState<int, ProductEntity> _removeFromList(
    ProductEntity product,
    PagingState<int, ProductEntity> currentPagingState,
  ) {
    final List<List<ProductEntity>> newPages = List.from(
      currentPagingState.pages ?? [],
    );
    final List<int> newKeys = List.from(currentPagingState.keys ?? []);

    for (int i = 0; i < newPages.length; i++) {
      final bool productExistsOnPage = newPages[i].any(
        (element) => element.id == product.id,
      );

      if (!productExistsOnPage) continue;

      final List<ProductEntity> newPage = List.from(newPages[i]);
      newPage.removeWhere((element) => element.id == product.id);

      if (newPage.isEmpty) {
        newPages.removeAt(i);
        newKeys.removeAt(i);
      } else {
        newPages[i] = newPage;
      }

      break;
    }

    return currentPagingState.copyWith(pages: newPages, keys: newKeys);
  }

  PagingState<int, ProductEntity> _updateItemInList(
    ProductEntity product,
    PagingState<int, ProductEntity> currentPagingState,
  ) {
    final List<List<ProductEntity>> newPages = List.from(
      currentPagingState.pages ?? [],
    );

    for (int i = 0; i < newPages.length; i++) {
      final page = newPages[i];
      final int productIndex = page.indexWhere(
        (element) => element.id == product.id,
      );

      if (productIndex == -1) continue;

      final List<ProductEntity> newPage = List.from(page);
      newPage[productIndex] = product;
      newPages[i] = newPage;
      break;
    }

    return currentPagingState.copyWith(pages: newPages);
  }

  //* Helpers
  void switchState() {
    if (_stateIsSearch()) {
      _resetSearch();
      emit(InventoryFeed(feedState));
      return;
    }

    emit(InventorySearch(searchState));
  }

  bool _stateIsSearch() {
    return state is InventorySearch;
  }
}

/// hold state for both feed and search
/// helper functions: 
///   refresh for both search and feed, 
///   refetch when search query change, 
///   toggle between search and feed and emit cached paging state
///   future<void> functions for fetchFeed and fetchSearch
/// 
///   if state is noMoreResults add to last page if length < limit