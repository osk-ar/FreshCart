import 'package:equatable/equatable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class CashierPaginationState extends Equatable {
  final PagingState<int, ProductEntity> pagingState;

  const CashierPaginationState(this.pagingState);

  CashierPaginationState copyWith({
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

    return CashierPaginationState(newState);
  }

  @override
  List<Object?> get props => [pagingState];
}

class CashierFeed extends CashierPaginationState {
  const CashierFeed(super.pagingState);

  @override
  CashierFeed copyWith({
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

    return CashierFeed(newState);
  }
}

class CashierSearch extends CashierPaginationState {
  const CashierSearch(super.pagingState);

  @override
  CashierSearch copyWith({
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

    return CashierSearch(newState);
  }
}
