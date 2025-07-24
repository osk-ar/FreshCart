class ProductEntity {
  int? id;
  String? name;
  double? price;
  int? quantity;
  String? imagePath;

  ProductEntity({
    this.id,
    this.name,
    this.price,
    this.quantity,
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
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return '''ProductEntity(id: $id, name: $name, price: $price, quantity: $quantity, imagePath: $imagePath)''';
  }
}
