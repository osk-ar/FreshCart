import 'package:supermarket/domain/entities/product_entity.dart';

abstract class InventoryEvent {}

//* CRUD
class InventoryFetchItemsEvent extends InventoryEvent {}

class InventoryAddItemEvent extends InventoryEvent {
  ProductEntity product;

  InventoryAddItemEvent(this.product);
}

class InventoryEditItemEvent extends InventoryEvent {
  ProductEntity product;

  InventoryEditItemEvent(this.product);
}

class InventoryRemoveItemEvent extends InventoryEvent {}

class InventoryRestockItemEvent extends InventoryEvent {}

//* Search
class InventoryStartSearchEvent extends InventoryEvent {}

class InventoryChangeSearchEvent extends InventoryEvent {
  String query;

  InventoryChangeSearchEvent(this.query);
}

class InventoryLoadMoreSearchEvent extends InventoryEvent {}

class InventoryEndSearchEvent extends InventoryEvent {}
