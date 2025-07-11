class ProductBatchEntity {
  int? id;
  int? productId;
  int? quantity;
  double? purchasePrice;
  DateTime? productionDate;
  DateTime? expiryDate;
  DateTime? receivedDate;

  ProductBatchEntity({
    this.id,
    this.productId,
    this.quantity,
    this.purchasePrice,
    this.productionDate,
    this.expiryDate,
    this.receivedDate,
  });

  ProductBatchEntity copyWith({
    int? id,
    int? productId,
    int? quantity,
    double? purchasePrice,
    DateTime? productionDate,
    DateTime? expiryDate,
    DateTime? receivedDate,
  }) {
    return ProductBatchEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      productionDate: productionDate ?? this.productionDate,
      expiryDate: expiryDate ?? this.expiryDate,
      receivedDate: receivedDate ?? this.receivedDate,
    );
  }
}
