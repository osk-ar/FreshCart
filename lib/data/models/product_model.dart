import 'package:supermarket/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    super.id,
    super.name,
    super.price,
    super.quantity,
    super.barcode,
    super.imagePath,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'] as int?,
      name: json['name'] as String?,
      price:
          (json['selling_price'] is int)
              ? (json['selling_price'] as int).toDouble()
              : json['selling_price'] as double?,
      quantity: json['quantity'] as int?,
      barcode: json['barcode'] as String?,
      imagePath: json['image_path'] as String?,
    );
  }
}
