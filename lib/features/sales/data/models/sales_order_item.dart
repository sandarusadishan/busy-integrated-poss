class SalesOrderItem {
  String id;
  String itemCode; // New
  String itemName;
  double quantity;
  String unit;
  double altQty; // New
  String altUnit; // New
  double price;
  double amount;
  double discount; // Existing discount field
  String? imageUrl;

  SalesOrderItem({
    required this.id,
    this.itemCode = '',
    this.itemName = '',
    this.quantity = 0.0,
    this.unit = '',
    this.altQty = 0.0,
    this.altUnit = '',
    this.price = 0.0,
    this.amount = 0.0,
    this.discount = 0.0,
    this.imageUrl,
  });

  SalesOrderItem copyWith({
    String? id,
    String? itemCode,
    String? itemName,
    double? quantity,
    String? unit,
    double? altQty,
    String? altUnit,
    double? price,
    double? amount,
    double? discount,
    String? imageUrl,
  }) {
    return SalesOrderItem(
      id: id ?? this.id,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      altQty: altQty ?? this.altQty,
      altUnit: altUnit ?? this.altUnit,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      discount: discount ?? this.discount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
