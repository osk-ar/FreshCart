class ProductEntity {
  final int? id;
  final String? name;
  final double? price;
  final int? quantity;
  final String? barcode;
  final String? imagePath;

  ProductEntity({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.barcode,
    this.imagePath,
  });

  ProductEntity copyWith({
    int? id,
    String? name,
    double? price,
    int? quantity,
    String? barcode,
    String? imagePath,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
