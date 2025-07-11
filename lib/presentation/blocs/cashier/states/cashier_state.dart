import 'package:equatable/equatable.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

abstract class CashierState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CashierInitial extends CashierState {}

class CashierLoading extends CashierState {}

class CashierLoaded extends CashierState {
  final List<ProductEntity> products;

  CashierLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CashierSearching extends CashierState {
  final List<ProductEntity> searchedProducts;

  CashierSearching(this.searchedProducts);

  @override
  List<Object?> get props => [searchedProducts];
}

class CashierError extends CashierState {
  final String error;

  CashierError(this.error);

  @override
  List<Object?> get props => [error];
}
