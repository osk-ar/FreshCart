import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class InventoryState {
  final PagingState<int, ProductEntity> pagingState;

  InventoryState(this.pagingState);

  InventoryState copyWith({
    List<List<ProductEntity>>? pages,
    List<int>? keys,
    Object? error,
    bool? hasNextPage,
    bool? isLoading,
  }) {
    final PagingState<int, ProductEntity> newState =
        PagingState<int, ProductEntity>(
          pages: pages ?? pagingState.pages,
          keys: keys ?? pagingState.keys,
          hasNextPage: hasNextPage ?? pagingState.hasNextPage,
          isLoading: isLoading ?? pagingState.isLoading,
          error: error ?? pagingState.error,
        );

    return InventoryState(newState);
  }
}

class InventoryFeed extends InventoryState {
  InventoryFeed(super.pagingState);

  @override
  InventoryFeed copyWith({
    List<List<ProductEntity>>? pages,
    List<int>? keys,
    Object? error,
    bool? hasNextPage,
    bool? isLoading,
  }) {
    final PagingState<int, ProductEntity> newState =
        PagingState<int, ProductEntity>(
          pages: pages ?? pagingState.pages,
          keys: keys ?? pagingState.keys,
          hasNextPage: hasNextPage ?? pagingState.hasNextPage,
          isLoading: isLoading ?? pagingState.isLoading,
          error: error ?? pagingState.error,
        );

    return InventoryFeed(newState);
  }
}

class InventorySearch extends InventoryState {
  InventorySearch(super.pagingState);

  @override
  InventorySearch copyWith({
    List<List<ProductEntity>>? pages,
    List<int>? keys,
    Object? error,
    bool? hasNextPage,
    bool? isLoading,
  }) {
    final PagingState<int, ProductEntity> newState =
        PagingState<int, ProductEntity>(
          pages: pages ?? pagingState.pages,
          keys: keys ?? pagingState.keys,
          hasNextPage: hasNextPage ?? pagingState.hasNextPage,
          isLoading: isLoading ?? pagingState.isLoading,
          error: error ?? pagingState.error,
        );

    return InventorySearch(newState);
  }
}
