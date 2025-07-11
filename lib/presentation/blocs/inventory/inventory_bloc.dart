import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/domain/repositories/db_local_repository.dart';
import 'package:supermarket/presentation/blocs/inventory/events/inventory_event.dart';
import 'package:supermarket/presentation/blocs/inventory/states/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final DBLocalRepository _dbLocalRepository;
  InventoryBloc(this._dbLocalRepository) : super(InventoryInitial()) {
    on<InventoryFetchItemsEvent>(_fetchItems);
    on<InventoryAddItemEvent>(_addItem);
    on<InventoryStartSearchEvent>((event, emit) => _startSearch(event, emit));
    on<InventoryChangeSearchEvent>(_searchItem);
    on<InventoryEndSearchEvent>(_endSearch);
  }
  List<ProductEntity> _items = [];
  List<ProductEntity> _searchedItems = [];

  bool isFeedLoadingMore = false;
  bool isSearchLoadingMore = false;
  bool isFeedLastItemReached = false;
  bool isSearchLastItemReached = false;

  int feedOffset = 0;
  int searchOffset = 0;
  static const int pageLimit = 20;

  String searchQuery = "";

  Future<void> _fetchItems(
    InventoryFetchItemsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (isFeedLoadingMore || isFeedLastItemReached) return;

    try {
      isFeedLoadingMore = true;

      final newItems = await _dbLocalRepository.getAllProducts(
        pageLimit,
        feedOffset,
      );

      if (newItems.length < pageLimit) {
        isFeedLastItemReached = true;
      }
      _items.addAll(newItems);
      feedOffset += newItems.length;

      emit(InventoryLoaded(_items));
      isFeedLoadingMore = false;
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _addItem(
    InventoryAddItemEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(InventoryLoading());

    try {
      await _dbLocalRepository.addProduct(event.product);
      _items.add(event.product);
      emit(InventoryLoaded(_items));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  void _startSearch(
    InventoryStartSearchEvent event,
    Emitter<InventoryState> emit,
  ) {
    searchOffset = 0;
    isSearchLastItemReached = false;

    emit(InventorySearching(_searchedItems));
  }

  Future<void> _searchItem(
    InventoryChangeSearchEvent event,
    Emitter<InventoryState> emit,
  ) async {
    _clearSearch();

    if (event.query.isEmpty) {
      searchQuery = event.query;
      emit(InventorySearching(_searchedItems));
      return;
    }

    emit(InventoryLoading());

    try {
      searchQuery = event.query;

      final newItems = await _dbLocalRepository.searchProducts(
        event.query,
        itemCount: pageLimit,
        offset: searchOffset,
      );

      if (newItems.length < pageLimit) {
        isSearchLastItemReached = true;
      }
      _searchedItems.addAll(newItems);
      searchOffset += newItems.length;

      log(_searchedItems.length.toString());
      log(_searchedItems.toString());
      log(searchQuery);
      log(event.query);

      emit(InventorySearching(_searchedItems));
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  Future<void> _loadMoreSearchItems(
    InventoryLoadMoreSearchEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (isSearchLoadingMore || isSearchLastItemReached) return;

    try {
      isSearchLoadingMore = true;

      final newItems = await _dbLocalRepository.searchProducts(
        searchQuery,
        itemCount: pageLimit,
        offset: searchOffset,
      );

      if (newItems.length < pageLimit) {
        isSearchLastItemReached = true;
      }
      _searchedItems.addAll(newItems);
      searchOffset += newItems.length;

      emit(InventorySearching(_searchedItems));
      isSearchLoadingMore = false;
    } catch (e) {
      emit(InventoryError(e.toString()));
    }
  }

  void _endSearch(
    InventoryEndSearchEvent event,
    Emitter<InventoryState> emit,
  ) async {
    _clearSearch();
    searchQuery = "";

    emit(InventoryLoaded(_items));
  }

  void _clearSearch() {
    _searchedItems = [];
    searchOffset = 0;
    isSearchLastItemReached = false;
  }
}
