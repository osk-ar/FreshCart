import 'dart:isolate';

import 'package:supermarket/data/datasource/local/db_local_datasource.dart';
import 'package:supermarket/data/models/product_model.dart';
import 'package:supermarket/domain/entities/product_batch_entity.dart';
import 'package:supermarket/domain/entities/product_entity.dart';
import 'package:supermarket/domain/repositories/db_local_repository.dart';

class DBLocalRepositoryImpl implements DBLocalRepository {
  final DBLocalDatasource _dbLocalDatasource;

  DBLocalRepositoryImpl(this._dbLocalDatasource);

  @override
  Future<int> addProduct(ProductEntity product) async {
    return await _dbLocalDatasource.addProduct(
      name: product.name!,
      sellingPrice: product.price!,
      quantity: 0,
      imagePath: product.imagePath,
    );
  }

  @override
  Future<List<ProductEntity>> getAllProducts(int itemCount, int offset) async {
    final List<Map<String, dynamic>> productsMap = await _dbLocalDatasource
        .getAllProducts(limit: itemCount, offset: offset);

    return Isolate.run(
      () =>
          productsMap.map((product) => ProductModel.fromMap(product)).toList(),
    );
  }

  @override
  Future<int> restockProduct(ProductBatchEntity batch) async {
    return await _dbLocalDatasource.restockItem(
      productId: batch.productId!,
      quantity: batch.quantity!,
      purchasePrice: batch.purchasePrice!,
      expiryDate: batch.expiryDate!,
      productionDate: batch.productionDate,
    );
  }

  @override
  Future<int> updateProduct(ProductEntity product) async {
    return await _dbLocalDatasource.updateProduct(
      productId: product.id!,
      name: product.name!,
      sellingPrice: product.price!,
      quantity: product.quantity!,
      imagePath: product.imagePath,
    );
  }

  @override
  Future<int> removeProduct(int productId) async {
    return await _dbLocalDatasource.deleteProduct(productId);
  }

  @override
  Future<List<ProductEntity>> searchProducts(
    String query, {
    int? itemCount,
    int? offset,
  }) async {
    final List<Map<String, dynamic>> searchedProductsMap =
        await _dbLocalDatasource.searchProducts(
          query,
          limit: itemCount,
          offset: offset,
        );

    return Isolate.run(
      () =>
          searchedProductsMap
              .map((product) => ProductModel.fromMap(product))
              .toList(),
    );
  }
}
