import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

class CashierCheckoutCubit extends Cubit<List<ProductEntity>> {
  CashierCheckoutCubit() : super([]);

  void addProduct(ProductEntity product) {
    emit([...state, product]);
  }

  void changeQuantity(int productId, int quantity) {
    emit(
      state
          .map(
            (pr) => pr.id != productId ? pr : pr.copyWith(quantity: quantity),
          )
          .toList(),
    );
  }

  void removeProduct(int productId) {
    emit(state.where((pr) => pr.id != productId).toList());
  }

  List<ProductEntity> getProducts() {
    return state;
  }

  void removeAll() {
    emit([]);
  }
}
