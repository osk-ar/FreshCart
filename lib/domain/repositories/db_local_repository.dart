import 'package:supermarket/domain/entities/product_batch_entity.dart';
import 'package:supermarket/domain/entities/product_entity.dart';

abstract interface class DBLocalRepository {
  Future<int> addProduct(ProductEntity product);
  Future<List<ProductEntity>> getAllProducts(int itemCount, int offset);
  Future<ProductEntity?> getProductById(int productId);
  Future<int> restockProduct(ProductBatchEntity batch);
  Future<int> updateProduct(ProductEntity product);
  Future<int> removeProduct(int productId);
  Future<List<ProductEntity>> searchProducts(
    String query, {
    int? itemCount,
    int? offset,
  });
}
