import 'package:supermarket/domain/entities/product_entity.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<ProductEntity> products;

  InventoryLoaded(this.products);
}

class InventoryError extends InventoryState {
  final String error;

  InventoryError(this.error);
}

class InventorySearching extends InventoryState {
  final List<ProductEntity> searchedProducts;

  InventorySearching(this.searchedProducts);
}
