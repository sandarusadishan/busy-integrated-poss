class SalesOrderItem {
  String id;
  String itemName;
  double quantity;
  String unit;
  double price;
  double amount;

  SalesOrderItem({
    required this.id,
    this.itemName = '',
    this.quantity = 0.0,
    this.unit = '',
    this.price = 0.0,
    this.amount = 0.0,
  });

  SalesOrderItem copyWith({
    String? id,
    String? itemName,
    double? quantity,
    String? unit,
    double? price,
    double? amount,
  }) {
    return SalesOrderItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      amount: amount ?? this.amount,
    );
  }
}
